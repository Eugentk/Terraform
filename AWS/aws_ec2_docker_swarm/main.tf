#----------------------------------------------------------------------------------------
# Terraform With Amazon web services
#
# Main.tf file
#
# Made by Tk.Eugen@gmail.com
#-----------------------------------------------------------------------------------------

terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }
  }
}
provider "aws" {
  region = var.region #Main region
}

#-------------------------------------------------------------------------------
#                                 EC2 AMI
#-------------------------------------------------------------------------------

data "aws_ami" "ubuntu_ami" { # Use latest version Ubuntu 22.04
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

#-------------------------------------------------------------------------------
#                                 EC2
#-------------------------------------------------------------------------------

resource "aws_instance" "server" {
  key_name               = var.ssh_key_name
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.server.id]
  subnet_id              = aws_subnet.aws-subnet-public.id
  root_block_device {
    volume_type = "gp2"
    volume_size = var.volume_size
  }
  tags = merge(var.main_tags, {
    Name = "Server for ${var.main_tags["Environment"]}"
  })
}

#-------------------------------------------------------------------------------
#                                 EC2 Elastic IP
#-------------------------------------------------------------------------------

resource "aws_eip" "static_ip" {
  instance = aws_instance.server.id
  vpc      = true
  tags = merge(var.main_tags, {
    Name = "Elastic IP for ${var.main_tags["Environment"]}"
  })
  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "./Ansible"
    destination = "/home/ubuntu"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install software-properties-common",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt install ansible --yes",
    ]
  }
  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu/Ansible && ansible-playbook playbook.yml -e @extra_vars.json",
    ]
  }
  provisioner "remote-exec" {
    inline = [
      "sudo docker stack deploy -c /home/ubuntu/app/docker-stack.yml app_name",
    ]
  }
}
#-------------------------------------------------------------------------------
#                                 EC2 SSH Key
#-------------------------------------------------------------------------------

resource "aws_key_pair" "EC2" {
  key_name   = var.ssh_key_name
  public_key = file(var.public_key_path)
}

#-------------------------------------------------------------------------------
#                                 EC2 Security group
#-------------------------------------------------------------------------------

resource "aws_security_group" "server" {
  name   = "Server SG"
  vpc_id = aws_vpc.Main_VPC.id
  tags = merge(var.main_tags, {
    Name = "Security Group ${var.main_tags["Environment"]}"
  })
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
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}
