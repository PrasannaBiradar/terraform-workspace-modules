provider "aws" {
    region = var.region
}


module "vpc" {
    source = "./modules/vpc"
    vpc_config = {
      cidr_block = var.vpc_cidr_range
      vpc_name = "${terraform.workspace}_vpc"
    }
    public_subnets = var.public_subnets

    private_subnets = var.private_subnets
}

module "load_balancer" {
    source = "./modules/load_balancer"
    lb_name = "${terraform.workspace}-load-balancer"
    load_balancer_type = var.load_balancer_type
    security_group_id = [module.vpc.my_vpc_security_group_id]
    subnet_ids = [for key in module.vpc.public_subnetss : key ]
    port = 80
    protocol = "HTTP"
    tg_name = "${terraform.workspace}-target-group"
    vpc_id = module.vpc.vpc_id
    my_target_group_name = "${terraform.workspace}_target_group"
}

resource "aws_instance" "my_instance" {
    instance_type = var.instance_type
    ami = var.ami_id
    key_name = var.key_name
    tags = {
      Name = "${terraform.workspace}_instance"
    }
    associate_public_ip_address = "true"
    subnet_id = module.vpc.public_subnetss[0]
    vpc_security_group_ids = [module.vpc.my_vpc_security_group_id]

    provisioner "remote-exec" {
      connection {
        type = "ssh"
        user = "ec2-user"
        host = self.public_ip
        private_key = file("./keys/${var.key_name}.pem")
      }
      inline = [ 
        "sudo yum update -y",
        "sudo yum install httpd -y",
        "sudo systemctl start httpd ",
        "sudo systemctl enable httpd",
        "sudo chmod -R 777 /var/www/"
       ]
    }

    provisioner "file" {
      connection {
        type = "ssh"
        user = "ec2-user"
        host = self.public_ip
        private_key = file("./keys/${var.key_name}.pem")
      }
        source = "./html_files/${terraform.workspace}/index.html"
        destination = "/var/www/html/index.html"
    }

}

resource "aws_ami_from_instance" "my_custom_ami" {
    name = "${terraform.workspace}_custom_ami"
    source_instance_id = aws_instance.my_instance.id
    tags = {
      Name = "${terraform.workspace}_custom_ami"
    }
    depends_on = [ aws_instance.my_instance ]
}

module "autoscaling" {
    source = "./modules/autoscaling"
    #launch template
    launch_template_name = "${terraform.workspace}_launch_template"
    image_id = aws_ami_from_instance.my_custom_ami.id
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [module.vpc.my_vpc_security_group_id]
    #autoscaling group
    name_prefix = "${terraform.workspace}_autoscaling_group"
    #availability_zones = var.availability_zones
    min_size = var.min_size
    max_size = var.max_size
    target_group_arn = module.load_balancer.target_group_arn
    desired_capacity = var.desired_capacity
    vpc_zone_subnet =  tomap(module.vpc.private_sbnt_ids)
}

