provider "aws" {
  region = "us-east-1"

}
module "vpc" {
  source               = "../../modules/vpc"
  name_prefix          = "my-demo-app"
  vpc_cidr_block       = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
  enable_nat_gateway   = false
}
output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}
output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}
output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}
output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
}