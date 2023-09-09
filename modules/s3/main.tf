resource "aws_s3_bucket" "main" {
  bucket = "bucket-kms-grants-000111"

  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Enforce encryption for added security
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingKMSEncryption.html#encryption-context
# resource "aws_s3_bucket_policy" "force_encryption" {
#   bucket = aws_s3_bucket.main.id
#   policy = data.aws_iam_policy_document.force_encryption.json
# }

# data "aws_iam_policy_document" "force_encryption" {
#   statement {
#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }

#     actions = [
#       "s3:PutObject",
#       "s3:ListBucket",
#     ]

#     resources = [
#       "${aws_s3_bucket.example.arn}/*",
#     ]
#   }
# }

# Not required, just to remove warnings
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}
