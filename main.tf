terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = "KMS Grants"
    }
  }
}

locals {
  iam_user_name = "John"
}

module "iam" {
  source        = "./modules/iam"
  iam_user_name = local.iam_user_name
  kms_key_arn   = module.kms_keys.key_s3_arn
  bucket_arn    = module.s3.bucket_arn
}

module "kms_keys" {
  source        = "./modules/kms/keys"
  iam_user_name = local.iam_user_name
}

module "kms_policies" {
  source = "./modules/kms/policies"

  kms_key_id_s3      = module.kms_keys.key_s3_id
  kms_key_id_handson = module.kms_keys.key_handson_id

  john_user_arn      = module.iam.john_arn
  adminprin_user_arn = module.iam.admin_principal_arn
}

module "s3" {
  source      = "./modules/s3"
  kms_key_arn = module.kms_keys.key_s3_arn
}

module "vpc" {
  source = "./modules/vpc"
  region = var.aws_region
}

module "ec2" {
  source = "./modules/ec2"
  vpc_id = module.vpc.vpc_id
  az     = module.vpc.az1
  subnet = module.vpc.subnet_pub1
}
