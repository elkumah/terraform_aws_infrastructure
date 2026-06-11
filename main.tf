# local variables are used to create a consistent naming convention for resources based on the project name and environment. The random_id resource is used to generate a unique suffix for the S3 bucket name to ensure it is globally unique. The EC2 instance is configured with user data to install and start an Apache web server, and the S3 bucket is configured with optional lifecycle rules and versioning based on input variables.
locals {
  project_name = "terraform-aws-infra"
  environment  = terraform.workspace
  prefix       = "${var.project_name}-${local.environment}"
}


resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# module blocks are used to include the VPC, EC2, and S3 modules. The VPC module is responsible for creating the VPC and subnets, while the EC2 module creates an EC2 instance within the VPC. The S3 module creates an S3 bucket with optional lifecycle rules and versioning based on input variables. Outputs are defined to provide details about the created EC2 instance and VPC.
module "vpc" {
  source               = "./modules/vpc"
  name_prefix          = local.prefix
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  enable_nat_gateway   = var.enable_nat_gateway

}
module "ec2" {
  source        = "./modules/ec2"
  name_prefix   = local.prefix
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_ids[0]
  instance_type = var.instance_type
  key_name      = var.key_name
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

}

module "s3" {
  source                = "./modules/s3"
  bucket_name           = "${local.prefix}-bucket-${random_id.bucket_suffix.hex}"
  enable_lifecycle_rule = var.enable_lifecycle_rule
  force_destroy         = local.environment != "prod"

  tags = {
    Environment = local.environment
    Project     = var.project_name
  }
}