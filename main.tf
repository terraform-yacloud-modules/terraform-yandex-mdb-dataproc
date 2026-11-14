resource "yandex_storage_bucket" "jobs" {
  count = var.create_bucket ? 1 : 0

  bucket                = var.bucket_name
  bucket_prefix         = var.bucket_name == null ? lower("${var.name}-") : null
  folder_id             = local.folder_id
  default_storage_class = var.bucket_storage_class
  max_size              = var.bucket_max_size
  force_destroy         = var.bucket_force_destroy
}

resource "yandex_storage_bucket_iam_binding" "jobs_service_account" {
  count = var.create_bucket && var.bucket_grant_service_account_access ? 1 : 0

  bucket  = yandex_storage_bucket.jobs[0].bucket
  role    = "storage.editor"
  members = ["serviceAccount:${var.service_account_id}"]
}

resource "yandex_dataproc_cluster" "dataproc_cluster" {
  description                    = var.description
  name                           = var.name
  labels                         = var.labels
  service_account_id             = var.service_account_id
  autoscaling_service_account_id = var.autoscaling_service_account_id
  bucket                         = var.create_bucket ? yandex_storage_bucket.jobs[0].bucket : var.bucket
  environment                    = var.environment
  folder_id                      = local.folder_id
  host_group_ids                 = var.host_group_ids
  log_group_id                   = var.log_group_id
  zone_id                        = var.zone_id
  ui_proxy                       = var.ui_proxy
  security_group_ids             = var.security_group_ids
  deletion_protection            = var.deletion_protection

  cluster_config {
    version_id = var.cluster_version

    hadoop {
      services        = var.hadoop_services
      properties      = var.hadoop_properties
      ssh_public_keys = var.ssh_public_keys
      oslogin         = var.hadoop_oslogin

      dynamic "initialization_action" {
        for_each = var.initialization_actions
        content {
          uri     = initialization_action.value.uri
          args    = initialization_action.value.args
          timeout = initialization_action.value.timeout
        }
      }
    }

    dynamic "subcluster_spec" {
      for_each = var.subcluster_specs
      content {
        name = subcluster_spec.value.name
        role = subcluster_spec.value.role
        resources {
          resource_preset_id = subcluster_spec.value.resources.resource_preset_id
          disk_type_id       = subcluster_spec.value.resources.disk_type_id
          disk_size          = subcluster_spec.value.resources.disk_size
        }
        subnet_id        = subcluster_spec.value.subnet_id
        hosts_count      = subcluster_spec.value.hosts_count
        assign_public_ip = subcluster_spec.value.assign_public_ip

        dynamic "autoscaling_config" {
          for_each = subcluster_spec.value.autoscaling_config
          content {
            max_hosts_count        = autoscaling_config.value.max_hosts_count
            preemptible            = autoscaling_config.value.preemptible
            warmup_duration        = autoscaling_config.value.warmup_duration
            stabilization_duration = autoscaling_config.value.stabilization_duration
            measurement_duration   = autoscaling_config.value.measurement_duration
            cpu_utilization_target = autoscaling_config.value.cpu_utilization_target
            decommission_timeout   = autoscaling_config.value.decommission_timeout
          }
        }
      }
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}

resource "yandex_dataproc_cluster_iam_binding" "this" {
  for_each = var.cluster_iam_bindings

  cluster_id = yandex_dataproc_cluster.dataproc_cluster.id
  role       = each.key
  members    = each.value
}
