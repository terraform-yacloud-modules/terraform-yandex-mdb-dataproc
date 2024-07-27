variable "name" {
  description = "Name of the Data Proc cluster"
  type        = string
}

variable "description" {
  description = "Description of the Data Proc cluster"
  type        = string
  default     = "Dataproc Cluster created by Terraform"
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the Data Proc cluster"
  type        = map(string)
  default     = {}
}

variable "service_account_id" {
  description = "Service account ID to be used by the Data Proc agent"
  type        = string
}

variable "zone_id" {
  description = "ID of the availability zone to create cluster in"
  type        = string
  default     = "ru-central1-b"
}

variable "cluster_version" {
  description = "Version of Data Proc image"
  type        = string
  default     = "2.0"
}

variable "hadoop_services" {
  description = "List of services to run on Data Proc cluster"
  type        = list(string)
  default     = ["HDFS", "YARN", "SPARK", "TEZ", "MAPREDUCE", "HIVE"]
}

variable "hadoop_properties" {
  description = "A set of key/value pairs that are used to configure cluster services"
  type        = map(string)
  default     = {}
}

variable "ssh_public_keys" {
  description = "List of SSH public keys to put to the hosts of the cluster"
  type        = list(string)
  default     = []
}

variable "initialization_actions" {
  description = "List of initialization scripts"
  type = list(object({
    uri     = string
    args    = list(string)
    timeout = number
  }))
  default = []
}

variable "subcluster_specs" {
  description = "Configuration of the Data Proc subcluster"
  type = list(object({
    name = string
    role = string
    resources = object({
      resource_preset_id = string
      disk_type_id       = string
      disk_size          = number
    })
    subnet_id        = string
    hosts_count      = number
    assign_public_ip = bool
    autoscaling_config = list(object({
      max_hosts_count        = number
      preemptible            = bool
      warmup_duration        = number
      stabilization_duration = number
      measurement_duration   = number
      cpu_utilization_target = number
      decommission_timeout   = number
    }))
  }))
  default = []
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "dataproc-network"
}

variable "subnet_name" {
  description = "Name of the VPC subnet"
  type        = string
  default     = "dataproc-subnet"
}

variable "v4_cidr_blocks" {
  description = "List of IPv4 CIDR blocks for the subnet"
  type        = list(string)
  default     = ["10.1.0.0/24"]
}

variable "service_account_name" {
  description = "Name of the service account"
  type        = string
  default     = "dataproc"
}

variable "service_account_description" {
  description = "Description of the service account"
  type        = string
  default     = "service account to manage Dataproc Cluster"
}

variable "folder_id" {
  description = "ID of the folder to create a cluster in"
  type        = string
}

# variable "bucket" {
#   description = "Name of the Object Storage bucket to use for Data Proc jobs"
#   type        = string
#   default     = "dataproc-bucket"
# }
