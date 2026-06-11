variable "bucket_name" {
  description = "The name of the S3 bucket to create"
  type        = string
}
variable "versioning" {
  description = "Whether to enable versioning on the S3 bucket"
  type        = bool
  default     = true
}
variable "force_destroy" {
  description = "Whether to force destroy the S3 bucket even if it contains objects"
  type        = bool
  default     = false
}
variable "enable_lifecycle_rule" {
  description = "Whether to enable a lifecycle rule to transition objects to Glacier after 30 days"
  type        = bool
  default     = false
}
variable "lifecycle_expiration_days" {
  description = "The number of days after which objects will be transitioned to Glacier (if lifecycle rule is enabled)"
  type        = number
  default     = 30
}
variable "noncurrent_version_expiration_days" {
  description = "Days before noncurrent object versions are deleted"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Additional tags to apply to the bucket"
  type        = map(string)
  default     = {}
}