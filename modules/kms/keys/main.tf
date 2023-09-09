
### KMS S3 ###
resource "aws_kms_key" "s3" {
  description             = "Testing grants"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "s3" {
  name          = "alias/testing-grants"
  target_key_id = aws_kms_key.s3.key_id
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
