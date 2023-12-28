resource "aws_security_group" "lb_sg" {
  name        = "${var.name}-${var.env}-lb_sg"
  description = "${var.name}-${var.env}-lb_sg"
  vpc_id      = var.vpc_id

  # access these for only app subnets
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allow_alb_cidr
  }

  # outside access
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, { Name = "${var.name}-${var.env}-lb_sg" })
}

resource "aws_lb" "alb" {
  name               = "${var.name}-${var.env}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnet_ids
  tags = merge(var.tags, { Name = "${var.name}-${var.env}-sg" })
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "unauthorized"
      status_code  = "403"
    }
  }
}