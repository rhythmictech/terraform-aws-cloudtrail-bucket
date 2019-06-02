output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.cloudtrail_bucket.arn
}

output "bucket_name" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.cloudtrail_bucket.bucket
}

output "kms_key_id" {
  description = "KMS key used by cloudtrail"
  value       = aws_kms_key.cloudtrail_key.arn
}

