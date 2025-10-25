output "id" {
  description = "ID of the Data Proc cluster."
  value       = module.dataproc_cluster.id
}

output "name" {
  description = "Name of the Data Proc cluster."
  value       = module.dataproc_cluster.name
}

output "zone_id" {
  description = "Zone ID of the Data Proc cluster."
  value       = module.dataproc_cluster.zone_id
}

output "service_account_id" {
  description = "Service account ID used by the Data Proc cluster."
  value       = module.dataproc_cluster.service_account_id
}

output "created_at" {
  description = "Creation timestamp of the Data Proc cluster."
  value       = module.dataproc_cluster.created_at
}
