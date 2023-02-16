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
#                                 VPC
#-------------------------------------------------------------------------------

resource "aws_vpc" "Application_VPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge(var.main_tags, {
    Name = "VPC ${var.main_tags["Environment"]}"
  })
}

data "aws_availability_zones" "available" {
  state = "available"
}
## Public subnet

resource "aws_subnet" "aws-subnet-public" {
  vpc_id            = aws_vpc.Application_VPC.id
  cidr_block        = var.vpc_cidr_public
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = merge(var.main_tags, {
    Name = "Public Subnet ${var.main_tags["Environment"]}"
  })
}

## Private subnet

resource "aws_subnet" "aws-subnet-private" {
  vpc_id            = aws_vpc.Application_VPC.id
  cidr_block        = var.vpc_cidr_private
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = merge(var.main_tags, {
    Name = "Privat Subnet ${var.main_tags["Environment"]}"
  })
}


## Internet gateway

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.Application_VPC.id
  tags = {
    Name = "Internet gateway"
  }
}


## Elastic IP for NAT GW

resource "aws_eip" "eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.gateway]
}


## NAT gateway

resource "aws_nat_gateway" "gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.aws-subnet-public.id
  depends_on    = [aws_internet_gateway.gateway]
}

#-------------------------------------------------------------------------------
#                                 Routing
#-------------------------------------------------------------------------------

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.Application_VPC.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

## Routing table

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.Application_VPC.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gateway.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Application_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

# Associate subnet public_subnet to public route table

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.aws-subnet-public.id
  route_table_id = aws_vpc.Application_VPC.main_route_table_id
}

# Associate subnet private_subnet to private route table

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.aws-subnet-private.id
  route_table_id = aws_route_table.private_route_table.id
}

