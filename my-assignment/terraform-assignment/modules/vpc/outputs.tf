output "vpc_id" {
    value = aws_vpc.my_vpc.id
    description = "display vpc id"
}

locals {
  public_subnets_output = {
    for key,config in local.public_subnets_list : key => {
        subnet_id = aws_subnet.public_subnet[key].id
        availability_zone = aws_subnet.public_subnet[key].availability_zone
    }
  }

  private_subnets_output = {
    for key,config in local.private_subnets_list : key => {
        subnet_id = aws_subnet.private_subnet[key].id 
        availability_zone = aws_subnet.private_subnet[key].availability_zone
    }
  }
}

output "public_sbnt_ids" {
  value = { for k,v in aws_subnet.public_subnet : k => v.id}
}

output "private_sbnt_ids" {
  value = { for k,v in aws_subnet.private_subnet : k => v.id}
}

locals {
  public_subnet_ids = {
    for key in range(length(local.public_subnets_list)): key => aws_subnet.public_subnet[key]
  }
}

locals {
  private_subnet_ids = {
    for key in range(length(local.private_subnets_list)): key => aws_subnet.private_subnet[key]
  }
}

output "my_vpc_security_group_id" {
  value = aws_security_group.aws_sec_grp.id
}

output "public_subnetss_ids" {
  value = local.public_subnet_ids
}

output "private_subnetss_ids" {
  value = local.private_subnet_ids
  
}

output "public_subnetss" {
    value = local.public_subnets_list
}

output "private_subnetss" {
    value = local.private_subnets_list
}
