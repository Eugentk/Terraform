#----------------------------------------------------------------------------------------
# Terraform With Amazon web services
#
# VPC.tf file
#
# Made by Tk.Eugen@gmail.com
#-----------------------------------------------------------------------------------------

resource "aws_vpc" "Application_VPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge(var.main_tags, {
    Name = "VPC ${var.main_tags["Environment"]}"
  })
}

## Public subnet primary
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "aws-subnet-public-primary" {
  vpc_id            = aws_vpc.Application_VPC.id
  cidr_block        = var.vpc_cidr_public_primary
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = merge(var.main_tags, {
    Name = "Public Subnet primary ${var.main_tags["Environment"]}"
  })
}

## Public subnet secondary

resource "aws_subnet" "aws-subnet-public-secondary" {
  vpc_id            = aws_vpc.Application_VPC.id
  cidr_block        = var.vpc_cidr_public_secondary
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = merge(var.main_tags, {
    Name = "Public Subnet secondary ${var.main_tags["Environment"]}"
  })
}


## Internet gateway

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.Application_VPC.id
  tags = {
    Name = "Internet gateway"
  }
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

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Application_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

# Associate subnet public_subnet_primary to public route table

resource "aws_route_table_association" "public_subnet_primary_association" {
  subnet_id      = aws_subnet.aws-subnet-public-primary.id
  route_table_id = aws_vpc.Application_VPC.main_route_table_id
}

# Associate subnet public_subnet_secondary to public route table

resource "aws_route_table_association" "public_subnet_secondary_association" {
  subnet_id      = aws_subnet.aws-subnet-public-secondary.id
  route_table_id = aws_vpc.Application_VPC.main_route_table_id
}