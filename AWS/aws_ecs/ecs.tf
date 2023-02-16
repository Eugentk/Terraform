#-------------------------------------------------------------------------------
#                                 ECS
#-------------------------------------------------------------------------------
resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name       = "${local.app_id}-cluster"
  depends_on = [aws_db_instance.application-db]
  tags = {
    Name        = "${local.app_id}-ecs"
    Environment = local.app_env
  }
}

resource "aws_cloudwatch_log_group" "log-group" {
  name = "${local.app_id}-app-logs"

  tags = {
    Application = local.app_id
    Environment = local.app_env
  }
}
data "aws_secretsmanager_secret_version" "db_host" {
  secret_id  = "${var.application_name}/${local.app_env}/database_host"
  depends_on = [aws_db_instance.application-db, aws_secretsmanager_secret_version.db_host]
}
locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.db_host.secret_string
  )
}
data "aws_secretsmanager_secret_version" "secret_key" {
  secret_id = "${var.application_name}/${local.app_env}"
}
locals {
  sec_key = jsondecode(
    data.aws_secretsmanager_secret_version.secret_key.secret_string
  )
}
data "template_file" "app" {
  template = file("templates/app.json.tpl")

  vars = {
    container_name        = var.container_name
    docker_image_url      = var.app_image
    region                = var.region
    log_group             = aws_cloudwatch_log_group.log-group.name
    database_url          = local.db_creds.DATABASE_URL
    postgres_username     = local.db_creds.POSTGRES_USERNAME
    postgres_password     = local.db_creds.POSTGRES_PASSWORD
    postgres_host         = local.db_creds.POSTGRES_HOST
    postgres_port         = local.db_creds.POSTGRES_PORT
    postgres_db           = local.db_creds.POSTGRES_DB
  }
}
resource "aws_ecs_task_definition" "aws-ecs-task" {
  family                   = "${local.app_id}-task"
  container_definitions    = data.template_file.app.rendered
  depends_on               = [aws_db_instance.application-db]
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 1024
  cpu                      = 512
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn
  tags = {
    Name        = "${local.app_id}-ecs-td"
    Environment = local.app_env
  }
}

resource "aws_ecs_service" "aws-ecs-service" {
  name                               = "${local.app_id}-ecs-service"
  cluster                            = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition                    = aws_ecs_task_definition.aws-ecs-task.arn
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  desired_count                      = 1
  force_new_deployment               = true
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  enable_execute_command = true

  lifecycle {
    ignore_changes = [task_definition]
  }

  network_configuration {
    subnets          = aws_subnet.aws-subnet-private.*.id
    assign_public_ip = false
    security_groups = [
      aws_security_group.service_security_group.id,
      aws_security_group.load_balancer_security_group.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = var.container_name
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.listener-https]
}

resource "aws_security_group" "service_security_group" {
  vpc_id = aws_vpc.Application_VPC.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.load_balancer_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${local.app_id}-service-sg"
    Environment = local.app_env
  }
}