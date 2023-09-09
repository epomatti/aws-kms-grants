data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = data.aws_region.current.name
}

### KMS S3 ###
resource "aws_kms_key" "main" {
  description             = "Testing grants"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "main" {
  name          = "alias/testing-grants"
  target_key_id = aws_kms_key.main.key_id
}

resource "aws_kms_key_policy" "main" {
  key_id = aws_kms_key.main.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "EvandroCustomTestingGrants"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.aws_account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow attachment of persistent resources"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.aws_account_id}:user/${var.iam_user_name}"
        }
        Action = [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "kms:ViaService" = [
              "ec2.${local.aws_region}.amazonaws.com",
              "rds.${local.aws_region}.amazonaws.com",
              "s3.${local.aws_region}.amazonaws.com",
            ]
          }
        }
      }
    ]
  })
}

### KMS Hands-on ###

resource "aws_kms_key" "handson" {
  description             = "Hands-on CMK"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "handson" {
  name          = "alias/hands-on"
  target_key_id = aws_kms_key.handson.key_id
}

resource "aws_kms_key_policy" "handson" {
  key_id = aws_kms_key.handson.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "EvandroCustomHandsOnCMK"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.aws_account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Given AdminPrin permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.aws_account_id}:user/AdminPrin"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}
