variable "vpc_cidr_block" {
    description = "The CIDR block for the VPC"
    type = string

}

variable "public_subnet_cidrs" {
    description = "The list of CIDR blocks for the public subnet"
    type = list(string)
}
variable "private_subnet_cidrs" {
    description = "The list of CIDR blocks for the private subnet"
    type = list(string)
}
variable "availability_zones"{
    description = "The list of availability zones for the VPC"
    type = list(string)
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