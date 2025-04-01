provider "aws" {
    region = "us-east-1"
}

resource "aws_lb" "load_balancer" {
    name = var.lb_name
    load_balancer_type = var.load_balancer_type
    internal = false
    security_groups = var.security_group_id
    subnets = var.subnet_ids
}

resource "aws_lb_listener" "load_balancer_listener" {
    load_balancer_arn = aws_lb.load_balancer.arn
    port = var.port
    protocol = var.protocol
    default_action {
        target_group_arn = aws_lb_target_group.lb_target_group.arn
        type = "forward"
    }
    depends_on = [ aws_lb_target_group.lb_target_group ]
}

resource "aws_lb_target_group" "lb_target_group" {
    name = var.tg_name
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id

    health_check {
        path = "/health"
        port = 80
        protocol = "HTTP"
        healthy_threshold = 5
        unhealthy_threshold = 2
        interval = 30
        timeout = 5
    }

    tags = {
      Name = var.my_target_group_name
    }
}
