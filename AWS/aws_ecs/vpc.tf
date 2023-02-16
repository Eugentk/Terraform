#-------------------------------------------------------------------------------
#                                 VPC
#-------------------------------------------------------------------------------

resource "aws_vpc" "Application_VPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${local.app_id}-vpc"
  }
}

## Public subnets

resource "aws_subnet" "aws-subnet-public" {
  vpc_id            = aws_vpc.Application_VPC.id
  count             = length(var.public_subnets)
  cidr_block        = element(var.public_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "${local.app_id}-public subnet-${count.index + 1}"
  }
}
## Private subnets

resource "aws_subnet" "aws-subnet-private" {
  vpc_id            = aws_vpc.Application_VPC.id
  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "${local.app_id}-private subnet-${count.index + 1}"
  }
}


## Internet gateway

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.Application_VPC.id
  tags = {
    Name = "${local.app_id}-internet-gateway"
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
  subnet_id     = aws_subnet.aws-subnet-public[0].id
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

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Application_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.Application_VPC.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gateway.id
}

# Associate subnet public_subnet to public route table

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.aws-subnet-public.*.id, count.index)
  route_table_id = aws_vpc.Application_VPC.main_route_table_id
}

# Associate subnet private_subnet to private route table

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.aws-subnet-private.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}
