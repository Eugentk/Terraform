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
variable "name" {
  description = "Name of the bucket."
  default     = "frontend_app_mobidev"
}
variable "storage_class" {
  description = "(Optional) The Storage Class of the new bucket. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE."
  default     = "REGIONAL"
}
variable "force_destroy" {
  description = "(Optional, Default: false) When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run."
  default     = false
}
variable "versioning_enabled" {
  description = "(Optional) While set to true, versioning is fully enabled for this bucket."
  default     = "true"
}
