#----------------------------------------------------------------------------
# Terraform
#
# Installation Dev Server
#
# Mady by Eugen Tkachenko
#
#---------------------------------------------------------------------------
provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}
data "aws_ami" "latest_version" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "aws_instance" "server" {
  key_name               = "my_key" #Name from ssh key
  ami                    = data.aws_ami.latest_version.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.server.id]
  user_data              = file("Autoinstalling Docker.sh")
  tags = {
    Name  = "Dev_Server from project "
    Owner = "Appus Studio"
  }
}

resource "aws_eip" "static_ip" {
  instance = aws_instance.server.id
  vpc      = true
  tags = {
    Name   = "IP address"
    owner  = "Appus Studio"
    region = var.region
  }
}

resource "aws_security_group" "server" {
  name        = "Server SG"
  description = "Security Group from Server"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #Office Ip addresses
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}
