terraform {
  backend "s3" {
    key = "terraform.tfstate"
  }
}

provider "aws" {
  profile = "${var.internal_aws_profile}"
}

data "aws_caller_identity" "internal" {}
