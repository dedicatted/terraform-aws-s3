# Terraform Module: terraform-aws-s3
# This module facilitates the creation of AWS S3 bucket with different options, including static website hosting, lifecycle rules configuration, server access logs, versioning.

## Overview
The `terraform-aws-s3` module includes configuration to easily deploy AWS S3. 

## Usage

Configuration that deploys s3 bucket with bucket policy and iam user that is allowed to access s3. You can find iam access kyes in AWS Parameter Store.
```hcl
module "s3" {
  source = "github.com/dedicatted/terraform-aws-s3"
}
```

Configuration to enable static website hosting
```hcl
module "s3" {
  source                 = "github.com/dedicatted/terraform-aws-s3"
  website_index_document = "index.html"
}
```

Configuration to apply lifecycle rules
```hcl
module "s3" {
  source                   = "github.com/dedicatted/terraform-aws-s3"
  s3_lifecycle_rule_prefix = ["dev/archive", "prod/archive"]
  s3_item_expiry_folder    = ["1", "30"]
}
```

Configuration to enable server access logging. Bucket for logs should be pre-created according to `https://docs.aws.amazon.com/AmazonS3/latest/userguide/enable-server-access-logging.html`
```hcl
module "s3" {
  source             = "github.com/dedicatted/terraform-aws-s3"
  logs_target_bucket = "<target_bucket>"
}
```

Configuration to enable versioning.
```hcl
module "s3" {
  source     = "github.com/dedicatted/terraform-aws-s3"
  versioning = "Enabled"
  mfa_delete = "Disabled"
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.33.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.accessKeys](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.s3_bucket_lifecycle_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_ownership_controls.bucket_ownership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.general_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.website_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.website_public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_ssm_parameter.access_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.secret_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_allowed_users"></a> [additional\_allowed\_users](#input\_additional\_allowed\_users) | Additional IAM users to grant access to s3 bucket. | `list(string)` | `[]` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the bucket. | `string` | `"dedicatted-abcdefg"` | no |
| <a name="input_create_s3_user"></a> [create\_s3\_user](#input\_create\_s3\_user) | IAM user to access s3 bucket. | `bool` | `true` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. | `bool` | `true` | no |
| <a name="input_logs_target_bucket"></a> [logs\_target\_bucket](#input\_logs\_target\_bucket) | Target bucket to store access logs. | `string` | `""` | no |
| <a name="input_mfa_delete"></a> [mfa\_delete](#input\_mfa\_delete) | Specifies whether MFA delete is enabled in the bucket versioning configuration. Valid values: Enabled or Disabled. | `string` | `""` | no |
| <a name="input_s3_item_expiry_folder"></a> [s3\_item\_expiry\_folder](#input\_s3\_item\_expiry\_folder) | S3 lifecycle rules expiration days. | `list(string)` | `[]` | no |
| <a name="input_s3_lifecycle_rule_prefix"></a> [s3\_lifecycle\_rule\_prefix](#input\_s3\_lifecycle\_rule\_prefix) | S3 lifecycle rules prefixes. | `list(string)` | `[]` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | Versioning state of the bucket. Valid values: Enabled, Suspended, or Disabled. Disabled should only be used when creating or importing resources that correspond to unversioned S3 buckets. | `string` | `""` | no |
| <a name="input_website_error_document"></a> [website\_error\_document](#input\_website\_error\_document) | Name of the error document for the website. | `string` | `"error.html"` | no |
| <a name="input_website_index_document"></a> [website\_index\_document](#input\_website\_index\_document) | Name of the index document for the website. | `string` | `""` | no |
| <a name="input_website_routing_rules"></a> [website\_routing\_rules](#input\_website\_routing\_rules) | JSON array containing routing rules describing redirect behavior and when redirects are applied. | `string` | `""` | no |

## Outputs

No outputs.
