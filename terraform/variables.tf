variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
  
}
variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
  
}
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
  
}
# s3 bucket variables
variable "s3_bucket_name" {
  description = "Name of the S3 bucket for CloudTrail logs"
  type        = string
}
variable "lambda_s3_bucket_name" {
  description = "Name of the S3 bucket for Lambda code"
  type        = string
}
variable "lambda_code_key" {
  description = "Key for the Lambda code in S3"
  type        = string
  default     = "lambda_function.zip" # Default name of the zip file in the bucket
}

# sns
variable "alert_email" {
  description = "Email address for SNS alerts"
  type        = string
}