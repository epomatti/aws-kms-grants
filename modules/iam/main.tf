# John - Key policies
resource "aws_iam_user" "john" {
  name = var.iam_user_name
  path = "/"

  force_destroy = true
}

resource "aws_iam_user_policy_attachment" "read_only_john" {
  user       = aws_iam_user.john.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}


# Anna - IAM permissions
resource "aws_iam_user" "anna" {
  name = "Anna"
  path = "/"

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
