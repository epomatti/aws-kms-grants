terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

locals {
  aws_account_id  = data.aws_caller_identity.current.account_id
  grant_user_name = "John"
}

### KMS ###
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
          AWS = "arn:aws:iam::${local.aws_account_id}:user/${local.grant_user_name}"
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
              "ec2.${var.region}.amazonaws.com",
              "rds.${var.region}.amazonaws.com"
            ]
          }
        }
      }
    ]
  })
}

# John - Key policies

resource "aws_iam_user" "john" {
  name = local.grant_user_name
  path = "/"
}

resource "aws_iam_user_policy_attachment" "read_only_john" {
  user       = aws_iam_user.john.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}


# Anna - IAM permissions

resource "aws_iam_user" "anna" {
  name = "Anna"
  path = "/"
}

data "aws_iam_policy_document" "kms" {
  statement {
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = [aws_kms_key.main.arn]
  }
}

resource "aws_iam_user_policy" "kms" {
  name   = "custom-kms-grant-policy"
  user   = aws_iam_user.anna.name
  policy = data.aws_iam_policy_document.kms.json
}

resource "aws_iam_user_policy_attachment" "read_only_anna" {
  user       = aws_iam_user.anna.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
