#----------------------------------------------------------------------------------------
# Terraform With Google Cloud Platform
#
# outputs.tf file
#
# Made by y.tkachenko@mobidev.biz
#-----------------------------------------------------------------------------------------

output "mysql_instance_name" {
  description = "The name of the postgres database instance"
  value       = google_sql_database_instance.db_mysql.name
}

output "mysql_public_ip_address" {
  description = "The public IPv4 address of the postgres instance."
  value       = google_sql_database_instance.db_mysql.public_ip_address
}

output "mysql_private_ip_address" {
  description = "The public IPv4 address of the postgres instance."
  value       = google_sql_database_instance.db_mysql.private_ip_address
}