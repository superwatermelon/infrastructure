terraform {
  backend "s3" {
    key = "seed.tfstate"
  }
}

provider "aws" {
  profile = "${var.internal_aws_profile}"
}

data "aws_caller_identity" "internal" {}
