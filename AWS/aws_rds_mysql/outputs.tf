#----------------------------------------------------------------------------------------
# Terraform With Amazon web services
#
# outputs.tf file
#
# Made by Tk.Eugen@gmail.com
#-----------------------------------------------------------------------------------------

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.application-db.endpoint
}
output "db_instance_port" {
  description = "The connection port"
  value       = aws_db_instance.application-db.port
}
