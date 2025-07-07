provider "aws" {
  region              = var.aws_region
  assume_role {
    role_arn = var.aws_oidc_role_arn
    session_name = "terraform-session"
  }
}