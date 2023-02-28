#----------------------------------------------------------------------------------------
# Terraform With Google Cloud Platform
#
# variables.tf file
#
# Made by y.tkachenko@mobidev.biz
#-----------------------------------------------------------------------------------------

variable "project" {
  description = "Project name on GCP"
  default = "skillup-351113"
}
variable "region" {
  description = "GCP region"
  default = "europe-west1"
}
variable "zone" {
  description = "GCP Zone name"
  default = "europe-west1-b"
}
variable "project_name" {
  description = "Name your project"
  default     = "mobidev"
}
variable "environments" {
  description = "Environments"
  default     = "prod"
}

