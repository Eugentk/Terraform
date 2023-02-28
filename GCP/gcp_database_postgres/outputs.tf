#----------------------------------------------------------------------------------------
# Terraform With Google Cloud Platform
#
# outputs.tf file
#
# Made by Tk.eugen@gmail.com
#-----------------------------------------------------------------------------------------

output "postgres_instance_name" {
  description = "The name of the postgres database instance"
  value       = google_sql_database_instance.db_postgres.name
}

output "postgres_public_ip_address" {
  description = "The public IPv4 address of the postgres instance."
  value       = google_sql_database_instance.db_postgres.public_ip_address
}

output "postgres_private_ip_address" {
  description = "The public IPv4 address of the postgres instance."
  value       = google_sql_database_instance.db_postgres.private_ip_address
}