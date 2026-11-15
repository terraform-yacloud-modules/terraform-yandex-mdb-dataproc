output "id" {
  description = "ID of the Data Proc cluster."
  value       = yandex_dataproc_cluster.dataproc_cluster.id
}

output "name" {
  description = "Name of the Data Proc cluster."
  value       = yandex_dataproc_cluster.dataproc_cluster.name
}

output "zone_id" {
  description = "Zone ID of the Data Proc cluster."
  value       = yandex_dataproc_cluster.dataproc_cluster.zone_id
}

output "service_account_id" {
  description = "Service account ID used by the Data Proc cluster."
  value       = yandex_dataproc_cluster.dataproc_cluster.service_account_id
}

output "bucket" {
  description = "Object Storage bucket used for Yandex Data Processing jobs."
  value       = var.create_bucket ? yandex_storage_bucket.jobs[0].bucket : var.bucket
}

output "bucket_domain_name" {
  description = "Domain name of the created Object Storage bucket for Yandex Data Processing jobs."
  value       = var.create_bucket ? yandex_storage_bucket.jobs[0].bucket_domain_name : null
}

output "created_at" {
  description = "Creation timestamp of the Data Proc cluster."
  value       = yandex_dataproc_cluster.dataproc_cluster.created_at
}
