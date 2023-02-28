#----------------------------------------------------------------------------------------
# Terraform With Google Cloud Platform
#
# Output.tf file
#
# Made by y.tkachenko@mobidev.biz
#-----------------------------------------------------------------------------------------
output "Server_IP" {
  value = "${google_compute_instance.lb_instance[*].network_interface.0.access_config.0.nat_ip}"
}
output "load_balancer_ip_address" {
  value       = google_compute_forwarding_rule.webservers-loadbalancer.ip_address
}