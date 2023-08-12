# Load Balancer Resource
resource "aws_lb" "clixxlb" {
  name               = "CLIXXLB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.stack-clixx.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Environment  = "Development"
    Organization = "Stack IT Solutions"
    OwnerEmail   = "mbabatola+development@gmail.com"
    Session      = "Stackcloud10"
  }
}

# Target Group Resource
resource "aws_lb_target_group" "clixx-tg" {
  name     = "ClIXX"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 3
  }
}

# Listener Resource
resource "aws_lb_listener" "clixx-listener" {
  load_balancer_arn = aws_lb.clixxlb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.clixx-tg.arn
  }
}
