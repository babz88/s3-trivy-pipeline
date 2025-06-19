provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "secure_bucket" {
  bucket = "my-secure-s3-bucket-example-12345678"

  tags = {
    Name        = "SecureBucket"
    Environment = "Dev"
  }

  force_destroy = false
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.secure_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bucket to store logs
resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-log-bucket-123456789"
}

# Main bucket with logging enabled
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "my-secure-s3-bucket-example-12345678"

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }

  tags = {
    Name        = "SecureBucket"
    Environment = "Dev"
  }

  force_destroy = false
}
