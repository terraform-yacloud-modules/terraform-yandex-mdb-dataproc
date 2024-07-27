resource "yandex_dataproc_cluster" "dataproc_cluster" {
  depends_on = [yandex_resourcemanager_folder_iam_binding.dataproc]

  #   bucket             = var.bucket
  description        = var.description
  name               = var.name
  labels             = var.labels
  service_account_id = var.service_account_id
  zone_id            = var.zone_id

  cluster_config {
    version_id = var.cluster_version

    hadoop {
      services        = var.hadoop_services
      properties      = var.hadoop_properties
      ssh_public_keys = var.ssh_public_keys

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
}

resource "yandex_vpc_network" "dataproc_network" {
  name = var.network_name
}

resource "yandex_vpc_subnet" "dataproc_subnet" {
  name           = var.subnet_name
  zone           = var.zone_id
  network_id     = yandex_vpc_network.dataproc_network.id
  v4_cidr_blocks = var.v4_cidr_blocks
}

resource "yandex_iam_service_account" "dataproc_sa" {
  name        = var.service_account_name
  description = var.service_account_description
}

data "yandex_resourcemanager_folder" "dataproc_folder" {
  folder_id = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "dataproc" {
  folder_id = data.yandex_resourcemanager_folder.dataproc_folder.id
  role      = "mdb.dataproc.agent"
  members = [
    "serviceAccount:${yandex_iam_service_account.dataproc_sa.id}",
  ]
}

# resource "yandex_resourcemanager_folder_iam_binding" "bucket_creator" {
#   folder_id = data.yandex_resourcemanager_folder.dataproc_folder.id
#   role      = "editor"
#   members = [
#     "serviceAccount:${yandex_iam_service_account.dataproc_sa.id}",
#   ]
# }

resource "yandex_iam_service_account_static_access_key" "dataproc_sa_key" {
  service_account_id = yandex_iam_service_account.dataproc_sa.id
}

# resource "yandex_storage_bucket" "dataproc_bucket" {
#   depends_on = [
#     yandex_resourcemanager_folder_iam_binding.bucket_creator
#   ]
#
#   bucket     = var.bucket
#   access_key = yandex_iam_service_account_static_access_key.dataproc_sa_key.access_key
#   secret_key = yandex_iam_service_account_static_access_key.dataproc_sa_key.secret_key
# }
