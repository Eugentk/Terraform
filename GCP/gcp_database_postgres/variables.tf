#----------------------------------------------------------------------------------------
# Terraform With Google Cloud Platform
#
# variables.tf file
#
# Made by y.tkachenko@mobidev.biz
#-----------------------------------------------------------------------------------------

variable "project" {
  description = "Project name on GCP"
  default     = "skillup-351113"
}
variable "region" {
  description = "GCP region"
  default     = "europe-west1"
}
variable "zone" {
  description = "GCP Zone name"
  default     = "europe-west1-b"
}
variable "engine" {
  description = "DB engine"
  default     = "POSTGRES_14"
}
variable "db_engine" {
  description = "DB engine type"
  default     = "db-f1-micro"
}
variable "db_name" {
  description = "DB name"
  default     = "terra"
}
variable "db_user_name" {
  description = "DB user name"
  default     = "superuser"
}
variable "db_password" {
  description = "DB Password"
  default     = "8m8PVmnqVIi6AShVk8Sh"
}
variable "project_name" {
  description = "Name your project"
  default     = "mobidev"
}
variable "environments" {
  description = "Environments"
  default     = "prod"
}

# OPTIONAL PARAMETERS

variable "maintenance_window_day" {
  description = "Day of week (1-7), starting on Monday, on which system maintenance can occur. Performance may be degraded or there may even be a downtime during maintenance windows."
  type        = number
  default     = 7
}
variable "maintenance_window_hour" {
  description = "Hour of day (0-23) on which system maintenance can occur. Ignored if 'maintenance_window_day' not set. Performance may be degraded or there may even be a downtime during maintenance windows."
  type        = number
  default     = 3
}
variable "maintenance_track" {
  description = "Receive updates earlier (canary) or later (stable)."
  type        = string
  default     = "stable"
}

variable "disk_autoresize" {
  description = "Second Generation only. Configuration to increase storage size automatically."
  type        = bool
  default     = true
}
variable "disk_size" {
  description = "Second generation only. The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased."
  type        = number
  default     = 10
}
variable "disk_type" {
  description = "The type of storage to use. Must be one of `PD_SSD` or `PD_HDD`."
  type        = string
  default     = "PD_SSD"
}