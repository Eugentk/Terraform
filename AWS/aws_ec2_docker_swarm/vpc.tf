#----------------------------------------------------------------------------------------
# Terraform With Amazon web services
#
# vpc.tf file
#
# Made by Tk.Eugen@gmail.com
#-----------------------------------------------------------------------------------------

resource "aws_vpc" "Main_VPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge(var.main_tags, {
    Name = "VPC ${var.main_tags["Environment"]}"
  })
}

## Public subnet

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "aws-subnet-public" {
  vpc_id            = aws_vpc.Main_VPC.id
  cidr_block        = var.vpc_cidr_public
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = merge(var.main_tags, {
    Name = "Public Subnet ${var.main_tags["Environment"]}"
  })
}

## Internet gateway

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.Main_VPC.id
  tags = {
    Name = "Internet gateway"
  }
}

#-------------------------------------------------------------------------------------------
#                                   VPC Routing
#-------------------------------------------------------------------------------------------

# Default route to Internet

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.Main_VPC.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Main_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

# Associate subnet public_subnet to public route table

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.aws-subnet-public.id
  route_table_id = aws_vpc.Main_VPC.main_route_table_id
}
