variable "allowed_account_ids" {
  default     = []
  description = "Optional list of AWS Account IDs that are permitted to write to the bucket"
  type        = list(string)
}

variable "bucket_name" {
  default     = null
  description = "Name of the S3 bucket to create. Defaults to {account_id}-{region}-cloudtrail."
  type        = string
}

variable "roles_allowed_kms_decrypt" {
  default     = []
  description = "Optional list of roles that have access to KMS decrypt and are permitted to decrypt logs"
  type        = list(string)
}

variable "lifecycle_rules" {
  description = "lifecycle rules to apply to the bucket"

  default = [
    {
      id                            = "expire-noncurrent-objects-after-ninety-days"
      noncurrent_version_expiration = 90
    },
    {
      id = "transition-to-IA-after-30-days"
      transition = [{
        days          = 30
        storage_class = "STANDARD_IA"
      }]
    },
    {
      id         = "delete-after-seven-years"
      expiration = 2557
    },
  ]

  type = list(object(
    {
      id                            = string
      enabled                       = optional(bool, true)
      expiration                    = optional(number)
      prefix                        = optional(number)
      noncurrent_version_expiration = optional(number)
      transition = optional(list(object({
        days          = number
        storage_class = string
      })))
  }))
}

variable "logging_bucket" {
  description = "S3 bucket with suitable access for logging requests to the cloudtrail bucket"
  type        = string
}

variable "region" {
  description = "Region to create KMS key in"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Mapping of any extra tags you want added to resources"
  type        = map(string)
}

variable "versioning_enabled" {
  default     = true
  description = "Whether or not to use versioning on the bucket. This can be useful for audit purposes since objects in a logging bucket should not be updated."
  type        = bool
}
