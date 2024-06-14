data "aws_iam_policy_document" "key" {
  statement {
    actions   = ["kms:*"]
    effect    = "Allow"
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:${local.partition}:iam::${local.account_id}:root"]
    }
  }

  statement {
    actions   = ["kms:GenerateDataKey*"]
    effect    = "Allow"
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = local.kms_key_encrypt_resources
    }

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]
    effect    = "Allow"
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["logs.${var.region}.amazonaws.com"]
    }
  }

  statement {
    actions   = ["kms:Describe*"]
    effect    = "Allow"
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "key_roles" {
  statement {
    actions   = ["kms:Decrypt"]
    effect    = "Allow"
    resources = ["*"]
    sid       = "AllowRolesToAccess"

    principals {
      type        = "AWS"
      identifiers = local.allow_kms_decrypt
    }
  }
}

data "aws_iam_policy_document" "key_empty" {
}

locals {
  json_w_decrypt  = [data.aws_iam_policy_document.key.json, data.aws_iam_policy_document.key_roles.json]
  json_wo_decrypt = [data.aws_iam_policy_document.key.json, data.aws_iam_policy_document.key_empty.json]
}

data "aws_iam_policy_document" "key_merged_policy" {
  source_policy_documents = length(local.allow_kms_decrypt) > 0 ? local.json_w_decrypt : local.json_wo_decrypt
}

resource "aws_kms_key" "this" {
  deletion_window_in_days = 7
  description             = "CloudTrail Encryption Key"
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.key_merged_policy.json
  tags = merge(
    {
      "Name" = "cloudtrail-key"
    },
    var.tags
  )
}

resource "aws_kms_alias" "this" {
  name          = "alias/cloudtrail_key"
  target_key_id = aws_kms_key.this.id
}
