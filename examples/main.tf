data "yandex_client_config" "client" {}

module "iam_accounts" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-iam.git//modules/iam-account"

  name      = "iam"
  folder_roles = [
    "admin",
    "dataproc.agent",
    "mdb.dataproc.agent",
  ]
  cloud_roles              = []
  enable_static_access_key = false
  enable_api_key           = false
  enable_account_key       = false

}

module "network" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-vpc.git"

  folder_id = data.yandex_client_config.client.folder_id

  blank_name = "vpc-nat-gateway"
  labels = {
    repo = "terraform-yacloud-modules/terraform-yandex-vpc"
  }

  azs = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]

  private_subnets = [["10.4.0.0/24"], ["10.5.0.0/24"], ["10.6.0.0/24"]]

  create_vpc         = true
  create_nat_gateway = true
}

module "dataproc_cluster" {
  source = "../"

  name        = "my-dataproc-cluster"
  description = "My Dataproc Cluster"
  labels = {
    environment = "production"
  }
  service_account_id = module.iam_accounts.id
  zone_id            = "ru-central1-a"
  cluster_version    = "2.0"
  hadoop_services    = ["HDFS", "YARN", "SPARK", "TEZ", "MAPREDUCE", "HIVE"]
  hadoop_properties = {
    "yarn:yarn.resourcemanager.am.max-attempts" = 5
  }
  ssh_public_keys = [
    file("~/.ssh/id_rsa.pub")
  ]
  #   initialization_actions = [
  #     {
  #       uri     = "s3a://your-bucket/scripts/script.sh"
  #       args    = ["arg1", "arg2"]
  #       timeout = 60
  #     }
  #   ]
  subcluster_specs = [
    {
      name = "main"
      role = "MASTERNODE"
      resources = {
        resource_preset_id = "s2.small"
        disk_type_id       = "network-hdd"
        disk_size          = 20
      }
      subnet_id          = module.network.private_subnets_ids[0]
      hosts_count        = 1
      assign_public_ip   = false
      autoscaling_config = []
    },
    {
      name = "data"
      role = "DATANODE"
      resources = {
        resource_preset_id = "s2.small"
        disk_type_id       = "network-hdd"
        disk_size          = 20
      }
      subnet_id          = module.network.private_subnets_ids[0]
      hosts_count        = 2
      assign_public_ip   = false
      autoscaling_config = []
    },
    {
      name = "compute"
      role = "COMPUTENODE"
      resources = {
        resource_preset_id = "s2.small"
        disk_type_id       = "network-hdd"
        disk_size          = 20
      }
      subnet_id        = module.network.private_subnets_ids[0]
      hosts_count      = 2
      assign_public_ip = false
      autoscaling_config = [
        {
          max_hosts_count        = 10
          preemptible            = false
          warmup_duration        = 60
          stabilization_duration = 120
          measurement_duration   = 60
          cpu_utilization_target = 70
          decommission_timeout   = 60
        }
      ]
    }
  ]
  network_name                = "vpc-nat-gateway" # vpc-nat-gateway
  subnet_name                 = "my-dataproc-subnet"
  v4_cidr_blocks              = ["10.1.0.0/24"]
  service_account_name        = "my-dataproc-sa"
  service_account_description = "Service account for my Dataproc Cluster"
  #   bucket                      = "my-dataproc-bucket"

  depends_on = [module.iam_accounts, module.network]
}
