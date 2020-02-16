data "aws_caller_identity" "current" {
}

locals {
  account_id = data.aws_caller_identity.current.account_id

  # Account IDs that will have access to stream CloudTrail logs
  account_ids = concat([local.account_id], var.allowed_account_ids)

  # Format account IDs into necessary resource lists.
  bucket_policy_put_resources = formatlist("${aws_s3_bucket.this.arn}/AWSLogs/%s/*", local.account_ids)
  kms_key_encrypt_resources   = formatlist("arn:aws:cloudtrail:*:%s:trail/*", local.account_ids)
}

resource "aws_s3_bucket" "this" {
  bucket = "${local.account_id}-${var.region}-cloudtrail"
  acl    = "private"
  tags   = var.tags

  lifecycle_rule {
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

  }

  logging {
    target_bucket = var.logging_bucket
    target_prefix = "${local.account_id}-${var.region}-cloudtrail/"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.this.arn
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "this" {
  statement {
    actions   = ["s3:GetBucketAcl"]
    effect    = "Allow"
    resources = [aws_s3_bucket.this.arn]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
  statement {
    actions   = ["s3:PutObject"]
    effect    = "Allow"
    resources = local.bucket_policy_put_resources

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}
