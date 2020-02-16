output "s3_bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.this.arn
}

output "s3_bucket_name" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.this.bucket
}

output "kms_key_id" {
  description = "KMS key used by cloudtrail"
  value       = aws_kms_key.this.arn
}
