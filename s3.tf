data "aws_caller_identity" "current" {}

resource "random_string" "bucket_name_prefix" {
  length  = 6
  special = false
}

resource "aws_s3_bucket" "bucket" {
  bucket        = var.random_prefix ? format("%s-%s", var.bucket_name, lower(random_string.bucket_name_prefix.result)) : var.bucket_name
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website_public_access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = var.website_index_document != "" ? false : true
  block_public_policy     = var.website_index_document != "" ? false : true
  ignore_public_acls      = var.website_index_document != "" ? false : true
  restrict_public_buckets = var.website_index_document != "" ? false : true
}

resource "aws_s3_bucket_policy" "general_s3_policy" {
  count  = var.website_index_document == "" ? 1 : 0
  bucket = aws_s3_bucket.bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = concat(
            var.create_s3_user ? [aws_iam_user.user[count.index].arn] : [],
            var.create_s3_role ? [aws_iam_role.s3_access_role[count.index].arn] : [],
            [data.aws_caller_identity.current.arn],
            var.additional_allowed_users
          )
        },
        Action   = "s3:*",
        Resource = ["${aws_s3_bucket.bucket.arn}/*", "${aws_s3_bucket.bucket.arn}"]
      },
      {
        Effect = "Deny",
        NotPrincipal = {
          AWS = concat(
            var.create_s3_user ? [aws_iam_user.user[count.index].arn] : [],
            var.create_s3_role ? [aws_iam_role.s3_access_role[count.index].arn] : [],
            [data.aws_caller_identity.current.arn],
            var.additional_allowed_users
          )
        },
        Action   = "s3:*",
        Resource = ["${aws_s3_bucket.bucket.arn}/*", "${aws_s3_bucket.bucket.arn}"]
      },
    ]
  })
}

resource "aws_s3_bucket_policy" "website_s3_policy" {
  count  = var.website_index_document != "" ? 1 : 0
  bucket = aws_s3_bucket.bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:GetObject",
      Resource  = "${aws_s3_bucket.bucket.arn}/*",
    }]
  })
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle_configuration" {
  count  = length(var.s3_lifecycle_rule_prefix) > 0 && length(var.s3_item_expiry_folder) > 0 ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  dynamic "rule" {
    for_each = range(length(var.s3_lifecycle_rule_prefix))

    content {
      id     = "cleanup_${var.s3_item_expiry_folder[rule.key]}_${var.s3_lifecycle_rule_prefix[rule.key]}"
      status = "Enabled"

      filter {
        prefix = var.s3_lifecycle_rule_prefix[rule.key]
      }

      expiration {
        days = var.s3_item_expiry_folder[rule.key]
      }
    }
  }
}

resource "aws_s3_bucket_website_configuration" "website" {
  count  = var.website_index_document != "" ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = var.website_index_document
  }

  error_document {
    key = var.website_error_document != "" ? var.website_error_document : ""
  }

  routing_rules = var.website_routing_rules != "" ? var.website_routing_rules : ""
}

resource "aws_s3_bucket_versioning" "versioning" {
  count  = var.versioning != "" && var.mfa_delete != "" ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status     = var.versioning
    mfa_delete = var.mfa_delete
  }
}

resource "aws_s3_bucket_logging" "example" {
  count  = var.logs_target_bucket != "" ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  target_bucket = var.logs_target_bucket
  target_prefix = "logs/"
}

