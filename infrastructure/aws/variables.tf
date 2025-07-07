variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_oidc_role_arn" {
  description = "ARN of the role to assume via OIDC"
  type        = string
}

variable "aws_ami" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
}

variable "aws_instance_type" {
  description = "Instance type"
  type        = string
  default     = "t3.micro"
}