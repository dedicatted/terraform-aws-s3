variable "bucket_name" {
  type        = string
  default     = "dedicatted-abcdefg"
  description = "Name of the bucket."
}

variable "force_destroy" {
  type        = bool
  default     = true
  description = "Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error."
}

variable "create_s3_user" {
  type        = bool
  default     = true
  description = "IAM user to access s3 bucket."
}

variable "create_s3_role" {
  type        = bool
  default     = true
  description = "IAM role to access s3 bucket."
}

variable "service_principal" {
  type        = string
  default     = "ec2.amazonaws.com"
  description = "Service that will assume this role if needed."
}

variable "additional_allowed_users" {
  type        = list(string)
  default     = []
  description = "Additional IAM users to grant access to s3 bucket."
}

variable "s3_lifecycle_rule_prefix" {
  type        = list(string)
  default     = []
  description = "S3 lifecycle rules prefixes."
}

variable "s3_item_expiry_folder" {
  type        = list(string)
  default     = []
  description = "S3 lifecycle rules expiration days."
}

variable "website_index_document" {
  type        = string
  default     = ""
  description = "Name of the index document for the website."
}

variable "website_error_document" {
  type        = string
  default     = "error.html"
  description = "Name of the error document for the website."
}

variable "website_routing_rules" {
  type        = string
  default     = ""
  description = "JSON array containing routing rules describing redirect behavior and when redirects are applied."
}

variable "versioning" {
  type        = string
  default     = ""
  description = "Versioning state of the bucket. Valid values: Enabled, Suspended, or Disabled. Disabled should only be used when creating or importing resources that correspond to unversioned S3 buckets."
}

variable "mfa_delete" {
  type        = string
  default     = ""
  description = "Specifies whether MFA delete is enabled in the bucket versioning configuration. Valid values: Enabled or Disabled."
}

variable "logs_target_bucket" {
  type        = string
  default     = ""
  description = "Target bucket to store access logs."
}
