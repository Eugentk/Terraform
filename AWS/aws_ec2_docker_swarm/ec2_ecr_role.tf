#----------------------------------------------------------------------------------------
# Terraform With Amazon web services
#
# ec2_ecr_role.tf file
#
# Made by Tk.Eugen@gmail.com
#-----------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#                                 EC2 IAM Role
#-------------------------------------------------------------------------------

resource "aws_iam_role" "ec2_ecr_role" {
  name = "ec2_connect_to_ecr"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
    }
  )
}

#-------------------------------------------------------------------------------
#                                 EC2 IAM Policy
#-------------------------------------------------------------------------------

resource "aws_iam_policy" "ec2_connect_policy" {
  name        = "ec2_connect_to_ecr"
  description = "Policy to provide permission to EC2"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "VisualEditor0"
        Effect = "Allow"
        Action = [
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:BatchDeleteImage",
          "ecr:ListImages",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:CompleteLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:UploadLayerPart"
        ]
        Resource = "*"
      },
      {
        Sid      = "VisualEditor1"
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      }
    ]
  })
}

#-------------------------------------------------------------------------------
#                                 EC2 IAM Policy Attachment
#-------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  role       = aws_iam_role.ec2_ecr_role.name
  policy_arn = aws_iam_policy.ec2_connect_policy.arn
}

#-------------------------------------------------------------------------------
#                                 IAM Instance profile
#-------------------------------------------------------------------------------

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "instance_profile"
  role = aws_iam_role.ec2_ecr_role.name
}