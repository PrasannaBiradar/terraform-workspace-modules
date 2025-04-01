variable "vpc_config" {
    description = "cidr block range for vpc"
    type = object({
        cidr_block = string
        vpc_name = string
    })
}

variable "public_subnets" {
    description = "cidr block range for public subnets"
    type = list(object({
      cidr_block = string
      availability_zone = string
    }))
}


variable "private_subnets" {
    description = "cidr block range for private subnet 1"
    type = list(object({
      cidr_block = string
      availability_zone = string
    }))
}


