#----------------------------------------------------------------------------------------
# Terraform With Google Cloud Platform
#
# Output.tf file
#
# Made by y.tkachenko@mobidev.biz
#-----------------------------------------------------------------------------------------
output "Server_IP" {
  value = "${google_compute_instance.docker_instance.network_interface.0.access_config.0.nat_ip}"
}