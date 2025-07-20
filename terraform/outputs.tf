output "bucket_name" {
  value = aws_s3_bucket.logicpro.bucket
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.logicpro_users.id
}

output "cognito_user_pool_client_id" {
  value = aws_cognito_user_pool_client.logicpro_client.id
}

output "cognito_login_url" {
  value = "https://${aws_cognito_user_pool_domain.logicpro_domain.domain}.auth.us-east-1.amazoncognito.com/login"
}
