#provider variables

variable "region" {
    description = "aws region"
    default = "us-east-1"
}

# VPC module variables
variable "vpc_cidr_range" {
    description = "vpc cidr block range"
}

variable "public_subnets" {
  description = "public subnet details"
  type = list(object({
    cidr_block = string
    availability_zone = string
  }))
}

variable "private_subnets" {
  description = "private subnet details"
  type = list(object({
    cidr_block = string
    availability_zone = string
  }))
}

# Load Balancer module variables

variable "load_balancer_type" {
    description = "type of load balancer being created"
    type = string
    default = "application"
}

#ec2 resource variables
variable "key_name" {
  description = "key name for ec2 instance login"
  type = string
}

variable "ami_id" {
  type = string
  description = "ami id for ec2 instance refence creation"
}

variable "instance_type" {
  description = "type of instance"
  default = "t2.micro"
}

# autoscaling  module variables

/*
 variable "availability_zones" {
  description = "availability_zones_list"
  type=list
}
*/

variable "min_size" {
  type = number
  default = 1
}

variable "max_size" {
  type = number
  default = 2
}

variable "desired_capacity" {
  type = number
  default = 2
}

