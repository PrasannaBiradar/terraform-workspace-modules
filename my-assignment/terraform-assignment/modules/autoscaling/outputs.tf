output "autoscaling_group_name" {
    value = aws_autoscaling_group.my-asg.name
}

output "autoscaling_group_arn" {
    value = aws_autoscaling_group.my-asg.arn
}

output "launch_template_name" {
    value = aws_launch_template.my_launch_template.name
}

output "launch_template_id" {
    value = aws_launch_template.my_launch_template.id
}


