#Creating VPC
resource "aws_vpc" "my_vpc" {
  tags = {
    Name = var.vpc_config.vpc_name
  }
  cidr_block = var.vpc_config.cidr_block
}

#--------------------------------------------------------------
#Creating Public and private subnets
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    count = length(var.public_subnets)
    #for_each = [var.public_subnets]

    cidr_block = var.public_subnets[count.index].cidr_block
    availability_zone = var.public_subnets[count.index].availability_zone

    tags = {
        Name = "public_subnet_${count.index}"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    count = length(var.private_subnets)
    #for_each = [var.private_subnets]

    availability_zone = var.private_subnets[count.index].availability_zone
    cidr_block = var.private_subnets[count.index].cidr_block

    tags = {
      Name = "private_subnet_${count.index}"
    }
}

locals {
    public_subnets_list = {
      for key in range(length(var.public_subnets)): key => aws_subnet.public_subnet[key].id
    }

    private_subnets_list = {
      for key in range(length(var.private_subnets)): key => aws_subnet.private_subnet[key].id
    }
}
#--------------------------------------------------------------
#create an internet gateway and nat gateway
resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "${terraform.workspace}_igw"
    }
}

resource "aws_eip" "my_eip" {
domain = "vpc"
}

resource "aws_nat_gateway" "my_natgw" {
  allocation_id = aws_eip.my_eip.id
  subnet_id = local.public_subnets_list[0]
  connectivity_type = "public"
}

#--------------------------------------------------------------
#create and associate public rouet table

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
      Name = "${terraform.workspace}_public_rt"
    }
}

resource "aws_route" "public_routes" {
    route_table_id = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "public_rt_association1" {
    count = length(var.public_subnets)
    #for_each = var.public_subnets
    route_table_id = aws_route_table.public_rt.id
    subnet_id = local.public_subnets_list[count.index]
    depends_on = [ aws_route_table.public_rt, aws_subnet.public_subnet]
}
#--------------------------------------------------------------
#create and associate private rouet table

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "${terraform.workspace}_private_rt"
    }   
}

resource "aws_route" "private_routes" {
    route_table_id = aws_route_table.private_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_natgw.id
}

resource "aws_route_table_association" "private_rt_association1" {
    count = length(var.private_subnets)
    #for_each = var.private_subnets
    route_table_id = aws_route_table.private_rt.id
    subnet_id = local.private_subnets_list[count.index]
}


#---------------------------------------------------------------
#Create security groups

resource "aws_security_group" "aws_sec_grp" {
    name = "allow access"
    description = "creating aws security group for instances"
    vpc_id = aws_vpc.my_vpc.id
    ingress {
        from_port = "22"
        to_port = "22"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = "80"
        to_port = "80"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    } 
}


