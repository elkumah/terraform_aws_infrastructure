variable "name_prefix" {
    description = "Prefix for resource names"
    type = string
}
variable "vpc_id" {
    description = "The ID of the VPC to deploy EC2 instances in"
    type = string
}
variable "subnet_id" {
    description = "The ID of the subnet to deploy EC2 instances in"
    type = string
}
variable "instance_type" {
    description = "The type of EC2 instance to deploy"
    type = string
    default = "t2.micro"
}
variable "key_name" {
    description = "The name of the SSH key pair to use for EC2 instances"
    type = string
    
}
variable "user_data" {
    description = "The user data script to run on EC2 instance launch"
    type = string
}
variable "ingress_rules" {
    description = "A list of ingress rules for the security group"
    type = list(object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
    }))
    default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
variable "root_volume_size" {
  description = "The size of the root EBS volume in GB"
  type = number
  default = 8  
}
variable "associated_public_ip" {
 description = "Whether to associate a public IP address with the EC2 instance"
 type = bool
 default = true 
}