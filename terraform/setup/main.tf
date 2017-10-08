variable "aws_profile" {
  description = "The AWS profile to use."
  type        = "string"
}

provider "aws" {
  alias   = "${var.aws_profile}"
  profile = "${var.aws_profile}"
}
