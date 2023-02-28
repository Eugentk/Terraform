#----------------------------------------------------------------------------------------
# Terraform With Google Cloud Platform
#
# variables.tf file
#
# Made by y.tkachenko@mobidev.biz
#-----------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
#-----------------------------------------------------------------------------------------

variable "project" {
  description = "Project ID on GCP"
  default = "skillup-351113"
}

variable "region" {
  description = "GCP region"
  default = "europe-west1"
}
variable "location" {
  description = "GCP Zone name"
  default = "europe-west1-b"
}

variable "application_name" {
  description = "Name your application name"
  default     = "mobidev"
}
variable "environments" {
  description = "Environments"
  default     = "prod"
}
#----------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
#----------------------------------------------------------------------------------------------

variable "cluster_service_account_name" {
  description = "The name of the custom service account used for the GKE cluster"
  type        = string
  default     = "private-cluster-sa"
}

variable "cluster_service_account_description" {
  description = "A description of the custom service account used for the GKE cluster."
  type        = string
  default     = "GKE Cluster Service Account managed by Terraform"
}
variable "machine_type" {
  description = "The node machine type"
  default = "e2-medium"
}
variable "disk_size" {
  description = "The node disk size"
  default = "30"
}
variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR (size must be /28) to use for the hosted master network. This range will be used for assigning internal IP addresses to the master or set of masters, as well as the ILB VIP. This range must not overlap with any other ranges in use within the cluster's network."
  type        = string
  default     = "10.5.0.0/28"
}
variable "master_authorized_cider_block" {
  description = "The IP range in CIDR for restrict access to the cluster master"
  type = string
  default = "0.0.0.0/0" # With a private cluster, it is highly recommended to restrict access to the cluster master
}

variable "vpc_cidr_block" {
  description = "The IP address range of the VPC in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27."
  type        = string
  default     = "10.3.0.0/16"
}

variable "vpc_secondary_cidr_block" {
  description = "The IP address range of the VPC's secondary address range in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27."
  type        = string
  default     = "10.4.0.0/16"
}

variable "public_subnetwork_secondary_range_name" {
  description = "The name associated with the pod subnetwork secondary range, used when adding an alias IP range to a VM instance.The name must be unique within the subnetwork."
  type        = string
  default     = "public-cluster"
}

variable "public_services_secondary_range_name" {
  description = "The name associated with the services subnetwork secondary range, used when adding an alias IP range to a VM instance. The name must be unique within the subnetwork."
  type        = string
  default     = "public-services"
}

variable "public_services_secondary_cidr_block" {
  description = "The IP address range of the VPC's public services secondary address range in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27. Note: this variable is optional and is used primarily for backwards compatibility, if not specified a range will be calculated using var.secondary_cidr_block, var.secondary_cidr_subnetwork_width_delta and var.secondary_cidr_subnetwork_spacing."
  type        = string
  default     = null
}

variable "private_services_secondary_cidr_block" {
  description = "The IP address range of the VPC's private services secondary address range in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27. Note: this variable is optional and is used primarily for backwards compatibility, if not specified a range will be calculated using var.secondary_cidr_block, var.secondary_cidr_subnetwork_width_delta and var.secondary_cidr_subnetwork_spacing."
  type        = string
  default     = null
}

variable "secondary_cidr_subnetwork_width_delta" {
  description = "The difference between your network and subnetwork's secondary range netmask; an /16 network and a /20 subnetwork would be 4."
  type        = number
  default     = 4
}

variable "secondary_cidr_subnetwork_spacing" {
  description = "How many subnetwork-mask sized spaces to leave between each subnetwork type's secondary ranges."
  type        = number
  default     = 0
}

variable "enable_vertical_pod_autoscaling" {
  description = "Enable vertical pod autoscaling"
  type        = string
  default     = true
}