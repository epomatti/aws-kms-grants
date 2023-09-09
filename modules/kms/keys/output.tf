output "key_s3_arn" {
  value = aws_kms_key.s3.arn
}

output "key_s3_id" {
  value = aws_kms_key.s3.id
}

output "key_handson_id" {
  value = aws_kms_key.handson.id
}
