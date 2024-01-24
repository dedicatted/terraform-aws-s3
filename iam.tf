resource "aws_iam_user" "user" {
  count = var.create_s3_user ? 1 : 0
  name  = "${var.bucket_name}-s3-user"
  path  = "/"
}

resource "aws_iam_access_key" "accessKeys" {
  count = var.create_s3_user ? 1 : 0
  user  = aws_iam_user.user[count.index].name
}

resource "aws_iam_user_policy" "policy" {
  count = var.create_s3_user ? 1 : 0
  name  = "${var.bucket_name}-iam-policy"
  user  = aws_iam_user.user[count.index].name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect" : "Allow",
      "Action" : [ "s3:*" ],
      "Resource" : ["${aws_s3_bucket.bucket.arn}", "${aws_s3_bucket.bucket.arn}/*"]
    }
  ]
}
EOF
}

resource "aws_ssm_parameter" "access_key" {
  count = var.create_s3_user ? 1 : 0
  name  = "/${aws_iam_user.user[count.index].name}-access-key"
  type  = "SecureString"
  value = aws_iam_access_key.accessKeys[count.index].id
}

resource "aws_ssm_parameter" "secret_key" {
  count = var.create_s3_user ? 1 : 0
  name  = "/${aws_iam_user.user[count.index].name}-secret-key"
  type  = "SecureString"
  value = aws_iam_access_key.accessKeys[count.index].secret
}
