#-------------------------------------------------------------------------------
#                                 RDS
#-------------------------------------------------------------------------------

resource "aws_db_instance" "application-db" {

  identifier = "${local.app_id}-db"

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type

  db_name  = replace(local.app_id, "-", "_")
  username = replace(local.app_id, "-", "_")
  password = local.db_password
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

  tags = {
    Name        = local.app_id
    Application = var.application_name
    Environment = local.app_env
  }
}

resource "aws_security_group" "db" {
  name   = "RDS SG"
  vpc_id = aws_vpc.Application_VPC.id
  tags = {
    Name = "${local.app_env}-sg"
  }
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

# Update secrets

resource "aws_secretsmanager_secret" "db_url" {
  name                           = "${var.application_name}/${local.app_env}/database_host"
  description                    = "Secret value is managed via Terraform"
  force_overwrite_replica_secret = true
  recovery_window_in_days        = 0
}
resource "aws_secretsmanager_secret_version" "db_host" {
  secret_id     = aws_secretsmanager_secret.db_url.id
  secret_string = <<EOF
 {
   "POSTGRES_USERNAME": "${aws_db_instance.application-db.username}",
   "POSTGRES_PASSWORD": "${urlencode(local.db_password)}",
   "POSTGRES_HOST": "${aws_db_instance.application-db.address}",
   "POSTGRES_PORT": "${aws_db_instance.application-db.port}",
   "POSTGRES_DB": "${aws_db_instance.application-db.db_name}",
   "DATABASE_URL": "${aws_db_instance.application-db.engine}://${aws_db_instance.application-db.username}:${urlencode(local.db_password)}@${aws_db_instance.application-db.address}/${aws_db_instance.application-db.db_name}"
}
   }
 EOF
}

resource "aws_secretsmanager_secret" "db_password" {
  name                           = "${var.application_name}/${local.app_env}/database_password"
  description                    = "Secret value is managed via Terraform"
  force_overwrite_replica_secret = true
  recovery_window_in_days        = 0
}
resource "aws_secretsmanager_secret_version" "password_db" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = <<EOF
 {
   "DATABASE_PASSWORD": "${local.db_password}"
}
   }
 EOF
}
# Create subnet group

resource "aws_db_subnet_group" "rds-public-subnet" {
  name       = "${local.app_id}-subnet group"
  subnet_ids = aws_subnet.aws-subnet-private.*.id
}

resource "random_password" "password" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
