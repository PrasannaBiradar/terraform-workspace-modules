variable "name_prefix" {
  type        = string
  description = "Prefix for the Auto Scaling Group name."
}

variable "min_size" {
  type        = number
  description = "Minimum number of instances in the Auto Scaling Group."
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum number of instances in the Auto Scaling Group."
  default     = 2
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of instances in the Auto Scaling Group."
  default     = 2
}

/*
variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones for the Auto Scaling Group."
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
*/


#variables for launch template
variable "launch_template_name" {
  type        = string
  description = "Name of the Launch Template to use."
}

variable "image_id" {
  type = string
  description = "image id for template"
}

variable "instance_type" {
  type = string
  description = "instance type for template"
  default = "t2.micro"
}

variable "key_name" {
  type = string
  description = "key name for template"
  default = "terraform-key"
}

variable "vpc_security_group_ids" {
  type = list(string)
  description = "id of security group for launch template"
}

variable "target_group_arn" {
  type = string
  description = "target group arn's"
}


variable "vpc_zone_subnet" {
  description = "vpc zone subnet ids"
}

