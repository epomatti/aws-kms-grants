output "john_arn" {
  value = aws_iam_user.john.arn
}

output "grantee_principal_arn" {
  value = aws_iam_user.grantee_principal.arn
}

output "retire_principal_arn" {
  value = aws_iam_user.retire_principal.arn
}

output "admin_principal_arn" {
  value = aws_iam_user.admin_principal.arn
}

output "access_key_id_grantee" {
  value = aws_iam_access_key.access_key_grantee_principal.id
}

output "access_key_id_retire" {
  value = aws_iam_access_key.access_key_retire_principal.id
}

output "access_key_id_admin" {
  value = aws_iam_access_key.access_key_admin_principal.id
}

output "access_key_secret_grantee" {
  value = aws_iam_access_key.access_key_grantee_principal.secret
}

output "access_key_secret_retire" {
  value = aws_iam_access_key.access_key_retire_principal.secret
}

output "access_key_secret_admin" {
  value = aws_iam_access_key.access_key_admin_principal.secret
}
