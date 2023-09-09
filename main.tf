terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  iam_user_name = "John"
}

module "iam" {
  source        = "./modules/iam"
  iam_user_name = local.iam_user_name
  kms_key_arn   = module.kms.key_arn
  bucket_arn    = module.s3.bucket_arn
}

module "kms" {
  source        = "./modules/kms"
  iam_user_name = local.iam_user_name
}

module "s3" {
  source      = "./modules/s3"
  kms_key_arn = module.kms.key_arn
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
