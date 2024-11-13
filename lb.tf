#LOUD BALANCE
resource "aws_lb" "ada" {
  name               = "ada-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app-ada.id]
  subnets            = [aws_subnet.public-a.id, aws_subnet.public-b.id, aws_subnet.public-c.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.ada.id
    prefix  = "ada-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

#TARGET GROUP
resource "aws_lb_target_group" "ada" {
  name     = "ada-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ada_vpc.id

  health_check {
        path                = "/"
        protocol            = "HTTP"
        port                = "traffic-port"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }
    tags = {
        Name = "ada-lb-tg-a"
    }
}

#LISTENER
resource "aws_lb_listener" "ada" {
  load_balancer_arn = aws_lb.ada.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ada.arn
  }
}


#TARGET GROUP ATTACHMENT
resource "aws_lb_target_group_attachment" "ada_a" {
  target_group_arn = aws_lb_target_group.ada.arn
  target_id        = aws_instance.ec2-a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "ada_b" {
  target_group_arn = aws_lb_target_group.ada.arn
  target_id        = aws_instance.ec2-b.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "ada_c" {
  target_group_arn = aws_lb_target_group.ada.arn
  target_id        = aws_instance.ec2-c.id
  port             = 80
}