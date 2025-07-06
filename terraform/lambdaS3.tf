resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket = var.lambda_s3_bucket_name
}

# policies and security
resource "aws_s3_bucket_public_access_block" "lambda_code_bucket_public_access_block" {
  bucket = aws_s3_bucket.lambda_code_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# versioning
resource "aws_s3_bucket_versioning" "lambda_code_bucket_versioning" {
  bucket = aws_s3_bucket.lambda_code_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# lifecycle rules
