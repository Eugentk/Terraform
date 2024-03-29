#----------------------------------------------------------------------------------------
# Terraform With Amazon web services
#
# variables.tf file
#
# Made by Tk.Eugen@gmail.com
#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
#-----------------------------------------------------------------------------------------

variable "region" {
  description = "Please Enter AWS region"
  default     = "eu-central-1" # Frankfurt region
}
# RDS Variables
variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
  default     = "application-stage"
}
variable "engine" {
  description = "The database engine to use" #
  type        = string
  default     = "mysql"
}
variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "8.0.20"
}
variable "port" {
  description = "The port on which the DB accepts connections"
  type        = string
  default     = "3306"
}
variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}
variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
  default     = "20"
}
variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'."
  type        = string
  default     = "gp2"
}

variable "db_name" {
  description = "The DB name to create"
  type        = string
  default     = "backend"
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
  sensitive   = true
  default     = "userdb"
}

variable "password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
  sensitive   = true
  default     = "XjRE7iH3e82dnwuf30Fz"
}
variable "cidr_blocks_allowed" {
  description = "Please Enter ip address to connect ssh"
  default     = ["0.0.0.0/0"] # Need Change
}
variable "main_tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Maintainer : "Eugen Tkachenko"
    Project : "Terraform RDS"
    Environment : "Dev"
  }
}

#----------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
#----------------------------------------------------------------------------------------------

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = []
}

variable "db_subnet_group_name" {
  description = "Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC"
  type        = string
  default     = ""
}

variable "availability_zone" {
  description = "The Availability Zone of the RDS instance"
  type        = string
  default     = ""
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
  type        = number
  default     = 0
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = true
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60."
  type        = number
  default     = 0
}
variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
  default     = true
}

variable "copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified)"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 1
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = "03:00-06:00"
}

variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true."
  type        = bool
  default     = false
}

variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = 0
}

variable "ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  type        = string
  default     = "rds-ca-2019"
}

# VPC Variables

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "172.10.0.0/16"
}

variable "vpc_cidr_public_primary" {
  description = "CIDR for the primary public subnet"
  default     = "172.10.0.0/24"
}

variable "vpc_cidr_public_secondary" {
  description = "CIDR for the secondary public subnet"
  default     = "172.10.1.0/24"
}


