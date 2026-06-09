provider "aws" {
    region = "us-east-1"
}
# Create a random suffix for the S3 bucket name to ensure uniqueness
resource "random_id" "bucket_suffix" {
  byte_length = 4
}
# Provision the S3 bucket using the S3 module with the provided variables and configurations.
module "s3" {
    source = "../../modules/s3"
    bucket_name = "my-demo-app-bucket-${random_id.bucket_suffix.hex}"
    force_destroy = true
    versioning = true
    enable_lifecycle_rule = true
    lifecycle_expiration_days = 30
    noncurrent_version_expiration_days = 30
    tags = {
        Environment = "Demo"
        Project     = "Terraform AWS Infra"
    }
}
output "bucket_id"                   { value = module.s3.bucket_id }
output "bucket_arn"                  { value = module.s3.bucket_arn }
output "bucket_domain_name"          { value = module.s3.bucket_domain_name }
output "bucket_regional_domain_name" { value = module.s3.bucket_regional_domain_name }
output "versioning_status"           { value = module.s3.versioning_status }
output "bucket_website_endpoint"    { value = module.s3.bucket_website_endpoint }