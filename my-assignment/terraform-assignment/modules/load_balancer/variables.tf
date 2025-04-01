variable "lb_name" {
    description = "name of load balancer"
    type = string
}

variable "load_balancer_type" {
    description = "type of load balancer"
    default = "application"
    type = string
}

variable "security_group_id" {
    description = "security group id"
    type = list
}

variable "subnet_ids" {
    description = "subnets list for load balancer"
    type = list(string)
}

variable "port" {
    description = "port value for load balancer listening"
    default = 80
}

variable "protocol" {
    description = "protocol for load balancer"
    default = "HTTP"
}

variable "tg_name" {
    description = "name for target group"
    type = string
}

variable "vpc_id" {
    description = "vpc id for vpc to be used for load balancer target groups"
}


variable "my_target_group_name" {
    description = "name for target group"
    type = string
}
