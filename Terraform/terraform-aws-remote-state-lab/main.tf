# Create S3 bucket for Terraform state
resource "aws_s3_bucket" "tf_state" {
  bucket = "my-terraform-state-bucket11223344" # Use a globally unique name
}

# Enable versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
