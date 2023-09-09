data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  aws_account_id        = data.aws_caller_identity.current.account_id
  aws_region            = data.aws_region.current.name
  aws_account_principal = "arn:aws:iam::${local.aws_account_id}:root"
}

resource "aws_kms_key_policy" "s3" {
  key_id = var.kms_key_id_s3

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "EvandroCustomTestingGrants"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "${local.aws_account_principal}"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow attachment of persistent resources"
        Effect = "Allow"
        Principal = {
          AWS = "${var.john_user_arn}"
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

resource "aws_kms_key_policy" "handson" {
  key_id = var.kms_key_id_handson

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "EvandroCustomHandsOnCMK"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "${local.aws_account_principal}"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Given AdminPrin permissions"
        Effect = "Allow"
        Principal = {
          AWS = "${var.adminprin_user_arn}"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}
