provider "aws" {
    region = "us-east-1"
  
}

module "vpc"{
    source = "../../modules/vpc"
    name_prefix = "my-demo-app"
    vpc_cidr_block= "10.0.0.0/16"
    public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
    availability_zones   = ["us-east-1a", "us-east-1b"]
    enable_nat_gateway   = false
}
module "ec2" {
    source = "../../modules/ec2"
    name_prefix = "my-demo-app"
    vpc_id = module.vpc.vpc_id
    subnet_id = module.vpc.public_subnet_ids[0]
    instance_type = "t3.micro"
    key_name = "terraform-ec2-key"
    user_data = <<-EOF
                #!/bin/bash
                # Update package index and install Apache web server
                apt-get update -y
                apt-get install -y apache2
                # Start Apache service and enable it to start on boot
                systemctl start apache2
                systemctl enable apache2
                # Create a simple index.html file to verify the web server is working
                echo "<html><body><h1>Welcome to my EC2 instance!</h1></body></html>" > /var/www/html/index.html
                EOF
               
    ingress_rules = [
        {
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        },
        {
            from_port   = 22
            to_port     = 22
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    ]
    root_volume_size = 8
    associated_public_ip = true
}

# Output the EC2 instance details
output "ec2_instance_id" {
    value = module.ec2.instance_id
}
output "ec2_public_ip" {
    value = module.ec2.public_ip
}   
output "ec2_private_ip" {
    value = module.ec2.private_ip
}
output "ec2_security_group_id" {
    value = module.ec2.security_group_id
}
output "ec2_ami_id" {
    value = module.ec2.ami_id
}
output "ec2_instance_type" {
    value = module.ec2.instance_type
}
output "vpc_id"{
    value = module.vpc.vpc_id
}