provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_role" "iam-role" {
    name = "my_role"
    assume_role_policy = jsonencode(
    {
        Version: "2012-10-17",
        Statement: [
            {
                Effect: "Allow",
                Action: [ "sts:AssumeRole"]
                Principal: {
                    Service: [ "ec2.amazonaws.com" ]
                }
            }
    ]
    })
    tags = {
      Environment = var.my_environment
    }
}

resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
    for_each = var.policies
    role = aws_iam_role.my-iam-role.name
    policy_arn = each.value
    depends_on = [ aws_iam_role.my-iam-role ]
}
