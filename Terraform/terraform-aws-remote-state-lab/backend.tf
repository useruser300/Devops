terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket11223344"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}