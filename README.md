# terraform-aws-cloudtrail-bucket

[![](https://github.com/rhythmictech/terraform-aws-cloudtrail-bucket/workflows/check/badge.svg)](https://github.com/rhythmictech/terraform-aws-cloudtrail-bucket/actions)

Create and manage a bucket suitable for encrypted CloudTrail logging. Supports inbound logging from multiple accounts through the `allowed_account_ids` var.

## Usage
```
module "cloudtrail-bucket" {
  source         = "git::https://github.com/rhythmictech/terraform-aws-cloudtrail-bucket"
  logging_bucket = module.s3logging-bucket.s3logging_bucket_name
  region         = var.region
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_account\_ids | Optional list of AWS Account IDs that are permitted to write to the bucket | `list(string)` | `[]` | no |
| bucket\_name | Name of the S3 bucket to create. Defaults to {account\_id}-{region}-cloudtrail. | `string` | `null` | no |
| logging\_bucket | S3 bucket with suitable access for logging requests to the cloudtrail bucket | `string` | n/a | yes |
| region | Region to create KMS key in | `string` | n/a | yes |
| roles\_allowed\_kms\_decrypt | Optional list of roles that have access to KMS decrypt and are permitted to decrypt logs | `list(string)` | `[]` | no |
| tags | Mapping of any extra tags you want added to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| kms\_key\_id | KMS key used by cloudtrail |
| s3\_bucket\_arn | The ARN of the bucket |
| s3\_bucket\_name | The name of the bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Related Projects
* [CloudTrail Logging module](https://github.com/rhythmictech/terraform-aws-cloudtrail-logging)
* [S3 Logging Module](https://github.com/rhythmictech/terraform-aws-s3logging-bucket)
