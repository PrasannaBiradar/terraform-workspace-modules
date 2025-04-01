#region details
region = "us-east-1"

#vpc details
vpc_cidr_range = "10.0.2.0/24"

public_subnets= [
  {
  availability_zone = "us-east-1a"
  cidr_block = "10.0.2.0/26"
  },
  {
  availability_zone = "us-east-1b"
  cidr_block = "10.0.2.64/26"
  }
]

private_subnets= [
  {
  availability_zone = "us-east-1a"
  cidr_block = "10.0.2.128/26"
  },
  {
  availability_zone = "us-east-1b"
  cidr_block = "10.0.2.192/26"
  }
]

#load balancer details
load_balancer_type = "application"

#aws instance details
instance_type = "t2.micro"
ami_id = "ami-071226ecf16aa7d96"
key_name = "terraform-key"
availability_zones = ["us-east-1a","us-east-1b"]

