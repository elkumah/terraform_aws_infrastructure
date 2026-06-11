variable "project_name" {
  type        = string
  description = "The name of the project for tagging purposes"
  default     = "my-demo-app"
}
variable "aws_region" {
  type        = string
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"
}
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}
variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for public subnets"
  type        = list(string)
}
variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks for private subnets"
  type        = list(string)
}
variable "availability_zones" {
  description = "A list of availability zones to deploy resources in"
  type        = list(string)
}
variable "enable_nat_gateway" {
  description = "Whether to enable a NAT gateway for private subnets"
  type        = bool
  default     = false
}
variable "instance_type" {
  description = "The type of EC2 instance to deploy"
  type        = string
  default     = "t3.micro"
}
variable "key_name" {
  description = "The name of the SSH key pair to use for EC2 instances"
  type        = string

}
variable "user_data" {
  description = "The user data script to run on EC2 instance launch"
  type        = string
}
variable "enable_versioning" {
  description = "Whether to enable versioning on the S3 bucket"
  type        = bool
  default     = true
}
variable "enable_lifecycle_rule" {
  description = "Whether to enable a lifecycle rule to transition objects to Glacier after 30 days"
  type        = bool
  default     = false
}