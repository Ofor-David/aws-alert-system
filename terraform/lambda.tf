# Upload Lambda deployment package to S3
resource "aws_s3_object" "lambda_package" {
  bucket = aws_s3_bucket.lambda_code_bucket.id
  key    = "lambda_function.zip" # Name of the zip file in the bucket
  source = "../lambda_function.zip" # Path to your zipped Lambda function in your repo
  etag   = filemd5("../lambda_function.zip")
}

# Create the Lambda function
resource "aws_lambda_function" "cloudtrail_log_processor" {
  function_name    = "cloudtrail-log-processor"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_function.lambda_handler" # Format: filename.functionname
  runtime          = "python3.12"
  timeout          = 10

  s3_bucket        = aws_s3_bucket.lambda_code_bucket.id
  s3_key           = aws_s3_object.lambda_package.key

  depends_on = [aws_iam_role_policy_attachment.lambda_policy_attachment]
}

# Allow S3 to trigger Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudtrail_log_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.cloudtrail_bucket.arn
}

# S3 Event Notification to trigger Lambda
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.cloudtrail_log_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

output "lambda_function_name" {
  description = "Name of the deployed Lambda function"
  value       = aws_lambda_function.cloudtrail_log_processor.function_name
}
