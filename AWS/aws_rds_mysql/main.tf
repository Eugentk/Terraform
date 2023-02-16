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
#                                 RDS MySQL
#-------------------------------------------------------------------------------
resource "aws_db_instance" "application-db" {

  identifier = var.identifier

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type

  db_name  = var.db_name
  username = var.username
  password = var.password
  port     = var.port


  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.rds-public-subnet.name

  availability_zone   = var.availability_zone
  multi_az            = var.multi_az
  iops                = var.iops
  publicly_accessible = var.publicly_accessible
  monitoring_interval = var.monitoring_interval

  apply_immediately     = var.apply_immediately
  maintenance_window    = var.maintenance_window
  skip_final_snapshot   = var.skip_final_snapshot
  copy_tags_to_snapshot = var.copy_tags_to_snapshot

  max_allocated_storage = var.max_allocated_storage

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window

  ca_cert_identifier = var.ca_cert_identifier

  deletion_protection = var.deletion_protection

  tags = merge(
    var.main_tags,
    {
      "Name" = format("%s", var.identifier)
    },
  )
}

resource "aws_security_group" "db" {
  name   = "RDS SG"
  vpc_id = aws_vpc.Application_VPC.id
  tags = merge(var.main_tags, {
    Name = "RDS  ${var.main_tags["Environment"]}"
  })
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks_allowed
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create subnet group

resource "aws_db_subnet_group" "rds-public-subnet" {
  name       = "rds-public-subnet"
  subnet_ids = [aws_subnet.aws-subnet-public-primary.id, aws_subnet.aws-subnet-public-secondary.id]
}




