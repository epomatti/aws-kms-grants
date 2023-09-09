# John - Key policies
resource "aws_iam_user" "john" {
  name = var.iam_user_name
  path = "/kms-grants/s3"

  force_destroy = true
}

resource "aws_iam_user_policy" "s3" {
  name = "JohnS3"
  user = aws_iam_user.john.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObjectAcl",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : "${var.bucket_arn}"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "read_only_john" {
  user       = aws_iam_user.john.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}


# Anna - IAM permissions
resource "aws_iam_user" "anna" {
  name = "Anna"
  path = "/kms-grants/s3"

  force_destroy = true
}

data "aws_iam_policy_document" "kms" {
  statement {
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = [var.kms_key_arn]
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


### Hands-on ###
resource "aws_iam_user" "grantee_principal" {
  name = "GranteePrin"
  path = "/kms-grants/hands-on"

  force_destroy = true
}

resource "aws_iam_user" "retire_principal" {
  name = "RetirePrin"
  path = "/kms-grants/hands-on"

  force_destroy = true
}

resource "aws_iam_user" "admin_principal" {
  name = "AdminPrin"
  path = "/kms-grants/hands-on"

  force_destroy = true
}

resource "aws_iam_user_policy_attachment" "admin" {
  user       = aws_iam_user.anna.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_access_key" "access_key_grantee_principal" {
  user = aws_iam_user.grantee_principal.name
}

resource "aws_iam_access_key" "access_key_retire_principal" {
  user = aws_iam_user.retire_principal.name
}

resource "aws_iam_access_key" "access_key_admin_principal" {
  user = aws_iam_user.admin_principal.name
}
