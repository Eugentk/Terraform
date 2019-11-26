variable "region" {
  description = "Please Enter AWS region"
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "Please Enter Instance Type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Please Enter You SSH Key"
}
