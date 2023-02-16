#----------------------------------------------------------------------------------------
# Terraform With Amazon web services
#
# outputs.tf file
#
# Made by Tk.Eugen@gmail.com
#-----------------------------------------------------------------------------------------

output "VPC_ID" {
  value = aws_vpc.Application_VPC.id
}

output "Public_subnet_ID" {
  value = aws_subnet.aws-subnet-public.id
}

output "Private_subnet_ID" {
  value = aws_subnet.aws-subnet-private.id
}