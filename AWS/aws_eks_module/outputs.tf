#----------------------------------------------------------------------------------------
# Terraform With Amazon web services
#
# outputs.tf file
#
# Made by Tk.Eugen@gmail.com
#-----------------------------------------------------------------------------------------
output "EKS_endpoint" {
  value = module.eks.cluster_arn
}