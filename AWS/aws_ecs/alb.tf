#-------------------------------------------------------------------------------
#                                 ALB
#-------------------------------------------------------------------------------
resource "aws_alb" "application_load_balancer" {
  name               = "${local.app_id}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.aws-subnet-public.*.id
  security_groups    = [aws_security_group.load_balancer_security_group.id]

  tags = {
    Name        = "${local.app_id}-alb"
    Environment = local.app_env
  }
}
resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = aws_vpc.Application_VPC.id

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "${local.app_id}-sg"
    Environment = local.app_env
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${local.app_id}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.Application_VPC.id

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200,301,302"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${local.app_id}-lb-tg"
    Environment = local.app_env
  }
}

resource "aws_lb_listener" "listener-http" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_listener" "listener-https" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:region:account_id:certificate/c7f2dd6e-917e-441d-ba92-806650e5fb75"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}
