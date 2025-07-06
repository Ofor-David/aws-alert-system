# iam role for lambda execution
resource "aws_iam_role" "lambda_execution_role" {
  name = "alert-system-lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

# iam policy for lambda execution
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_s3_sns_cloudwatch_policy"
  description = "Allows Lambda to access S3, SNS, and CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # S3 Read Access
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObject"
        ],
        Resource = "${aws_s3_bucket.cloudtrail_logs_bucket.arn}/*"
      },
      # S3 Read Access
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObject"
        ],
        Resource = "${aws_s3_bucket.lambda_code_bucket.arn}/*"
      },
      # SNS Publish Access
      {
        Effect   = "Allow",
        Action   = "sns:Publish",
        Resource = "${aws_sns_topic.alert_system_topic.arn}"
      },

      # CloudWatch Logs Access
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

output "lambda_role_arn" {
  description = "The ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_execution_role.arn
}