provider "aws" {
  region = "us-east-1"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "logicpro" {
  bucket        = "logicpro-projects-${random_id.suffix.hex}"
  force_destroy = true

  tags = {
    Name        = "LogicPro Projects Bucket"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_versioning" "logicpro" {
  bucket = aws_s3_bucket.logicpro.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logicpro" {
  bucket = aws_s3_bucket.logicpro.id

 rule {
  id     = "glacier-and-delete-old-versions"
  status = "Enabled"

  filter {
    prefix = "" # Applies to all objects in the bucket
  }

  noncurrent_version_transition {
    noncurrent_days = 0
    storage_class   = "GLACIER"
  }

  noncurrent_version_expiration {
    noncurrent_days = 10
  }
 }
}

resource "aws_cognito_user_pool" "logicpro_users" {
  name = "logicpro-users"

  auto_verified_attributes = ["email"]

  username_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  tags = {
    Name = "LogicPro User Pool"
  }
}

resource "aws_cognito_user_pool_client" "logicpro_client" {
  name         = "logicpro-client"
  user_pool_id = aws_cognito_user_pool.logicpro_users.id
  generate_secret = false
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
}

resource "aws_cognito_user_pool_domain" "logicpro_domain" {
  domain       = "logicpro-${random_id.suffix.hex}"
  user_pool_id = aws_cognito_user_pool.logicpro_users.id
}
