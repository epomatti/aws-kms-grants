output "grantee_principal_arn" {
  value = module.iam.grantee_principal_arn
}

output "retire_principal_arn" {
  value = module.iam.retire_principal_arn
}

output "admin_principal_arn" {
  value = module.iam.admin_principal_arn
}


output "access_key_id_grantee" {
  value = module.iam.access_key_id_grantee
}

output "access_key_id_retire" {
  value = module.iam.access_key_id_retire
}

output "access_key_id_admin" {
  value = module.iam.access_key_id_admin
}


output "access_key_secret_grantee" {
  value     = module.iam.access_key_secret_grantee
  sensitive = true
}

output "access_key_secret_retire" {
  value     = module.iam.access_key_secret_retire
  sensitive = true
}

output "access_key_secret_admin" {
  value     = module.iam.access_key_secret_admin
  sensitive = true
}
