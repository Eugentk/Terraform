#-------------------------------------------------------------------------------
#                                 AIM
#-------------------------------------------------------------------------------

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${local.app_id}-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    Name        = "${local.app_id}-iam-role"
    Environment = local.app_env
  }
}
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = sort(["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"])
    }
  }
}

resource "aws_iam_role_policy" "ecsTaskExecutionRole_policy" {
  name   = "${local.app_id}-execution-task-role-policy"
  role   = aws_iam_role.ecsTaskExecutionRole.id
  policy = data.aws_iam_policy_document.role_policy.json
}

data "aws_iam_policy_document" "role_policy" {
  statement {
    actions = [
      "ecr:*",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "secretsmanager:GetSecretValue",
      "ssm:GetParameters",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}