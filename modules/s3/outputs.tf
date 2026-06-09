# Outputs for S3 module
output "bucket_id" {
    description = "The name of the S3 bucket"
    value       = aws_s3_bucket.this.id
}
output "bucket_arn" {
    description = "The ARN of the S3 bucket"
    value       = aws_s3_bucket.this.arn
}
output "bucket_domain_name" {
    description = "The domain name of the S3 bucket"
    value       = aws_s3_bucket.this.bucket_domain_name
}
output "bucket_regional_domain_name" {
    description = "The regional domain name of the S3 bucket"
    value       = aws_s3_bucket.this.bucket_regional_domain_name
}
output "bucket_website_endpoint" {
    description = "The website endpoint of the S3 bucket (if website hosting is enabled)"
    value       = aws_s3_bucket.this.website_endpoint
}
output "bucket_versioning_status" {
    description = "The versioning status of the S3 bucket"
    value       = aws_s3_bucket_versioning.this.versioning_configuration[0].status
}