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

variable "ui_proxy" {
  description = "Whether to enable UI Proxy feature"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "A list of security group IDs that the cluster belongs to"
  type        = list(string)
  default     = []
}

variable "deletion_protection" {
  description = "Inhibits deletion of the cluster"
  type        = bool
  default     = false
}

variable "cluster_version" {
  description = "Version of Data Proc image"
  type        = string
  default     = "2.0"

  validation {
    condition     = contains(["1.0", "1.1", "1.2", "1.3", "1.4", "2.0", "2.1"], var.cluster_version)
    error_message = "Cluster version must be one of: 1.0, 1.1, 1.2, 1.3, 1.4, 2.0, 2.1"
  }
}

variable "hadoop_services" {
  description = "List of services to run on Data Proc cluster"
  type        = list(string)
  default     = ["HDFS", "YARN", "SPARK", "TEZ", "MAPREDUCE", "HIVE"]

  validation {
    condition = alltrue([
      for service in var.hadoop_services : contains(["HDFS", "YARN", "SPARK", "TEZ", "MAPREDUCE", "HIVE", "ZOOKEEPER", "HBASE", "SQOOP", "FLUME", "OOZIE", "HUE", "LIVY", "ZEPPELIN"], service)
    ])
    error_message = "Hadoop service must be one of: HDFS, YARN, SPARK, TEZ, MAPREDUCE, HIVE, ZOOKEEPER, HBASE, SQOOP, FLUME, OOZIE, HUE, LIVY, ZEPPELIN"
  }
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

variable "hadoop_oslogin" {
  description = "Whether to enable authorization via OS Login for Hadoop cluster"
  type        = bool
  default     = false
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

variable "autoscaling_service_account_id" {
  description = "Service account ID to be used for autoscaling operations"
  type        = string
  default     = null
}

variable "bucket" {
  description = "Object Storage bucket for Yandex Data Processing jobs"
  type        = string
  default     = null
}

variable "environment" {
  description = "Deployment environment of the cluster. Can be either PRESTABLE or PRODUCTION"
  type        = string
  default     = "PRODUCTION"

  validation {
    condition     = contains(["PRESTABLE", "PRODUCTION"], var.environment)
    error_message = "Environment must be either PRESTABLE or PRODUCTION"
  }
}

variable "host_group_ids" {
  description = "A list of host group IDs to place VMs of the cluster on"
  type        = list(string)
  default     = []
}

variable "log_group_id" {
  description = "ID of the cloud logging group for cluster logs"
  type        = string
  default     = null
}

variable "folder_id" {
  description = "ID of the folder to create the cluster in"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Timeout settings for cluster operations"
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
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

  validation {
    condition = alltrue([
      for spec in var.subcluster_specs : contains(["MASTERNODE", "DATANODE", "COMPUTENODE"], spec.role)
    ])
    error_message = "Subcluster role must be one of: MASTERNODE, DATANODE, COMPUTENODE"
  }

  validation {
    condition = alltrue([
      for spec in var.subcluster_specs : spec.resources.disk_size > 0
    ])
    error_message = "Disk size must be greater than 0"
  }

  validation {
    condition = alltrue([
      for spec in var.subcluster_specs : contains(["network-hdd", "network-ssd", "network-ssd-nonreplicated", "network-ssd-io-m3", "local-ssd", "network-ssd-io-m2"], spec.resources.disk_type_id)
    ])
    error_message = "Disk type must be one of: network-hdd, network-ssd, network-ssd-nonreplicated, network-ssd-io-m3, local-ssd, network-ssd-io-m2"
  }

  validation {
    condition = alltrue([
      for spec in var.subcluster_specs : contains(["s2.small", "s2.medium", "s2.large", "s2.xlarge", "s2.2xlarge", "s2.3xlarge", "m2.small", "m2.medium", "m2.large", "m2.xlarge", "m2.2xlarge", "m2.3xlarge", "m3.small", "m3.medium", "m3.large", "m3.xlarge", "m3.2xlarge", "m3.3xlarge"], spec.resources.resource_preset_id)
    ])
    error_message = "Resource preset must be one of: s2.small, s2.medium, s2.large, s2.xlarge, s2.2xlarge, s2.3xlarge, m2.small, m2.medium, m2.large, m2.xlarge, m2.2xlarge, m2.3xlarge, m3.small, m3.medium, m3.large, m3.xlarge, m3.2xlarge, m3.3xlarge"
  }

  validation {
    condition = alltrue([
      for spec in var.subcluster_specs : alltrue([
        for config in spec.autoscaling_config : config.cpu_utilization_target >= 0 && config.cpu_utilization_target <= 100
      ])
    ])
    error_message = "CPU utilization target must be between 0 and 100 percent"
  }
}
