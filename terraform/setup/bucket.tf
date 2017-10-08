variable "tfstate_bucket" {
  description = "The name of the S3 bucket for tfstate."
  type        = "string"
}

resource "aws_s3_bucket" "tfstate_bucket" {
  provider = "aws.${var.aws_profile}"
  bucket   = "${var.tfstate_bucket}"
  acl      = "private"

  versioning {
    enabled = true
  }
}

output "tfstate_bucket" {
  value = "${aws_s3_bucket.tfstate_bucket.id}"
}

output "tfstate_bucket_arn" {
  value = "${aws_s3_bucket.tfstate_bucket.arn}"
}
