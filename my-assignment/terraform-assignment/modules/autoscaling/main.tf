resource "aws_launch_template" "my_launch_template" {
    name = var.launch_template_name
    image_id = var.image_id
    instance_type = var.instance_type
    description = "my launch template required for autoscaling"
    vpc_security_group_ids = var.vpc_security_group_ids
    tag_specifications {
        resource_type = "instance"
        tags = {
            Name = "my-launch-template"
        }
    }
    key_name = var.key_name
}

resource "aws_autoscaling_group" "my-asg" {
    name_prefix = var.name_prefix
    desired_capacity = var.desired_capacity
    min_size = var.min_size
    max_size = var.max_size
    #availability_zones = var.availability_zones
    launch_template {
        id = aws_launch_template.my_launch_template.id
        version = "1"
    }
    vpc_zone_identifier = values(var.vpc_zone_subnet)
    target_group_arns = [var.target_group_arn]
    depends_on = [ aws_launch_template.my_launch_template ]
}
