resource "aws_iam_role" "cognito_authenticated_role" {
  name = "cognito-authenticated-s3-access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "cognito-identity.amazonaws.com:aud" = "IDENTITY_POOL_ID_PLACEHOLDER"
          },
          "ForAnyValue:StringLike" = {
            "cognito-identity.amazonaws.com:amr" = "authenticated"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "cognito_s3_access_policy" {
  name = "cognito-s3-access-policy"
  role = aws_iam_role.cognito_authenticated_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.logicpro.arn}",
          "${aws_s3_bucket.logicpro.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "allow_cognito_users" {
  bucket = aws_s3_bucket.logicpro.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowCognitoIAMRoleAccess",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.cognito_authenticated_role.arn
        },
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.logicpro.arn}",
          "${aws_s3_bucket.logicpro.arn}/*"
        ]
      }
    ]
  })
}
