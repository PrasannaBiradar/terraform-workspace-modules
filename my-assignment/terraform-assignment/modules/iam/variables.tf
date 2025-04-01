variable "role_name" {
    description = "give a role name for iam"
    type = string
}

variable "my_environment" {
    description = "environment in which iam role will be created"
}

variable "policies" {
    description = "policies list to be attachec to the iam role"
    type = list(string)
}


