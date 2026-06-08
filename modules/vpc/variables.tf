variable "vpc_cidr_block" {
    description = "The CIDR block for the VPC"
    type = string
    default = "10.0.0.0/16"

}

variable "public_subnet_cidrs" {
    description = "The list of CIDR blocks for the public subnet"
    type = list(string)
    default = ["10.0.10.0/24", "10.0.11.0/24"]
}
variable "private_subnet_cidrs" {
    description = "The list of CIDR blocks for the private subnet"
    type = list(string)
    default = ["10.0.10.0/24", "10.0.11.0/24"]
}
variable "availability_zones"{
    description = "The list of availability zones for the VPC"
    type = list(string)
    default = ["us-east-1a", "us-east-1b"]
}

variable "enable_nat_gateway" {
    description = "Whether to create a NAT gateway for the private subnets"
    type = bool
    default = true
}
variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
} 