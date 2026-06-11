output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}
output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}
output "ec2_instance_id" {
  value = module.ec2.instance_id
}
output "ec2_public_ip" {
  value = module.ec2.public_ip
}
output "ec2_private_ip" {
  value = module.ec2.private_ip
}
output "bucket_id" {
  value = module.s3.bucket_id
}
output "bucket_arn" {
  value = module.s3.bucket_arn
}
output "environment" {
  value = local.environment
}