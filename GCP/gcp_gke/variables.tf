#----------------------------------------------------------------------------------------
# Terraform With Google Cloud Platform
#
# variables.tf file
#
# Made by y.tkachenko@mobidev.biz
#-----------------------------------------------------------------------------------------

variable "project" {
  description = "Project ID on GCP"
  default = "skillup-351113"
}

variable "region" {
  description = "GCP region"
  default = "europe-west1"
}
variable "zone" {
  description = "GCP Main Zone name"
  default = "europe-west1-b"
}
variable "zone2" {
  description = "Second GCP Zone name"
  default = "europe-west1-d"
}
variable "node_count" {
  description = "Count for k8s nodes"
  default = 1
}
variable "node_machine_type" {
  description = "Node machine type"
  default = "e2-small"
}

variable "project_name" {
  description = "Name your project"
  default     = "mobidev"
}
variable "environments" {
  description = "Environments"
  default     = "prod"
}

