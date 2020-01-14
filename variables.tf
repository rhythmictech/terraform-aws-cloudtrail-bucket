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
