terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "env/project-name/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "your-terraform-lock-table"
    encrypt        = true
  }
}
