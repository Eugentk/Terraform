#----------------------------------------------------------------------------------------
# Terraform With Amazon web services
#
# variables.tf file
#
# Made by Tk.Eugen@gmail.com
#-----------------------------------------------------------------------------------------

variable "region" {
  description = "AWS Region"
  default     = "eu-central-1" # Frankfurt region
}
variable "cluster_name" {
  description = "Cluster name"
  default = "api-eks"
}
variable "vpc_name" {
  description = "VPC Name"
  default = "VPC Stage"
}
variable "worker_group_name" {
  description = "Worker group name"
  default = "api-worker-eks"
}
variable "instance_type" {
  description = "instance type"
  default = "t3a.xlarge"
}
variable "key_pair_name" {
  description = "AWS Key Pair name"
  default = "Cluster_key"
}
variable "public_key_path" {
  description = "Public key"
  default = "./eks.pub"
}
variable "main_tags" {
  description = "Common tags"
  type = map(string)
  default = {
    Project : "api"
    Environment: "Stage"
  }
}
