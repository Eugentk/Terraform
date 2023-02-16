#----------------------------------------------------------------------------------------
# Terraform With Amazon web services
#
# alb.tf file
#
# Made by Tk.Eugen@gmail.com
#-----------------------------------------------------------------------------------------

data "aws_subnets" "subnets" {
  filter {
    name   = "tag:Name"
    values = ["Public"] # insert values here
  }
}
resource "aws_lb" "application" {
  name                       = "app-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_servers.id]
  subnets                    = aws_subnet.aws-subnet-public-primary.*.id
  enable_deletion_protection = false

  tags = merge(var.main_tags, {
    Name = "Aplication LB for ${var.main_tags["Environment"]}"
  })
  depends_on = [aws_subnet.aws-subnet-public-primary]
}

resource "aws_lb_target_group" "app-target-group" {
  name        = "app-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.Application_VPC.id

  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}
resource "aws_lb_target_group_attachment" "servers_attachment" {
  count            = length(aws_instance.server.*.id)
  target_group_arn = aws_lb_target_group.app-target-group.id
  target_id        = element(aws_instance.server.*.id, count.index)
}

resource "aws_lb_listener" "app-alb-listener" {
  load_balancer_arn = aws_lb.application.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-target-group.arn
  }
}
