resource "aws_security_group" "main" {
  name        = "${var.env}"-"${var.type}-alb"
  description = "${var.env}"-"${var.type}-alb"
  vpc_id      = var.vpc_id

  ingress = {
      description = "APP"
      from_port = var.lb_port
      to_port = var.lb_port
      protocol = "tcp"
      cidr_blocks= var.sg_cidr 
  }

 egress = {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(var.tags, {Name = "${var.env}"-"${var.type}-alb"})
  }

resource "aws_lb" "main" {
  name               = "${var.env}"-"${var.type}"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnets


  tags = merge(var.tags, {Name = "${var.env}"-"${var.type}-alb"})
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
}



resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "${var.component}"- "${var.env}"
  type    = "A"
  ttl     = 30
  records = [aws_lb.main.dns_name]
}

  



