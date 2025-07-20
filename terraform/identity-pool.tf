resource "aws_cognito_identity_pool" "logicpro_identity_pool" {
  identity_pool_name               = "logicpro-identity-pool"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id         = aws_cognito_user_pool_client.logicpro_client.id
    provider_name     = aws_cognito_user_pool.logicpro_users.endpoint
    server_side_token_check = false
  }
}

resource "aws_cognito_identity_pool_roles_attachment" "attach_roles" {
  identity_pool_id = aws_cognito_identity_pool.logicpro_identity_pool.id

  roles = {
    authenticated = aws_iam_role.cognito_authenticated_role.arn
  }
}
