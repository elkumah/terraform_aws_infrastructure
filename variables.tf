variable "project_name" {
    type = string
    description = "The name of the project for tagging purposes"
    default= "my-demo-app"
}
variable "aws_region" {
    type = string
    description = "The AWS region to deploy resources in"
    default = "us-east-1"
}