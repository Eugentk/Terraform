#----------------------------------------------------------------------------
# Terraform
#
# Server
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
output "latest_version_linux" {
  value = data.aws_ami.latest_version.id
}

resource "aws_instance" "server" {
  #key_name               = "my_key.pem"
  ami                    = data.aws_ami.latest_version.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.server.id]
  tags = {
    Name  = "Server from ADV-IT"
    Owner = "Eugen Tkachenko"
  }
}

resource "aws_eip" "static_ip" {
  instance = aws_instance.server.id
  tags = {
    Name   = "IP address"
    owner  = "Eugen Tkachenko"
    region = var.region
  }
}
#-----------------------------------------
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
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}
#---------------------------------------------
#resource "aws_key_pair" "ssh_key" {
#  key_name   = "ssh_key"
#  public_key = "${file("/home/evgeniytkachenko/Documents/Terraform/Terraform.pem")}"
#}

#-----------------------------------------------------------------
#
resource "aws_launch_configuration" "web" {
  name            = "Server_LC"
  image_id        = data.aws_ami.latest_version.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.server.id]
  lifecycle {
    create_before_destroy = true
  }
}

#----------------------------------------------------------------
#
resource "aws_autoscaling_group" "web" {
  name                 = "WebServer_ASG"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = 1
  max_size             = 1
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id]
  health_check_type    = "EC2"
}

/*tags = [
  {
    key                 = "Name"
    value               = "WebServer"
    propagate_at_launch = true
  },
  {
    key                 = "Owner"
    value               = "Eugen Tkachenko"
    propagate_at_launch = true
  },
]
*/
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

#-----------------------------------------------------------------
output "ip" {
  value = aws_eip.static_ip.public_ip
}
