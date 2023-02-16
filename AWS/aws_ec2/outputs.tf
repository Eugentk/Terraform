#----------------------------------------------------------------------------------------
# Terraform With Amazon web services
#
# outputs.tf file
#
# Made by Tk.Eugen@gmail.com
#-----------------------------------------------------------------------------------------

output "Elastic_IP" {
  value = aws_eip.static_ip.public_ip
}