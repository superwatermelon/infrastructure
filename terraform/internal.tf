variable "seed_tfstate_bucket" {
  description = "The name of the seed tfstate bucket"
  type        = "string"
}

variable "internal_aws_profile" {
  description = "The profile of the internal AWS account."
  type        = "string"
}

variable "internal_tfstate_bucket" {
  description = "The name of the S3 bucket for internal tfstate."
  type        = "string"
}

module "internal" {
  source               = "./setup"
  aws_profile          = "${var.internal_aws_profile}"
  tfstate_bucket       = "${var.internal_tfstate_bucket}"
  principal_arn        = "arn:aws:iam::${data.aws_caller_identity.internal.account_id}:root"
  deployment_role_name = "deployment-internal"
}

resource "aws_iam_role_policy" "seed_tfstate_bucket_policy" {
  name     = "seed_tfstate_bucket_policy"
  role     = "${module.internal.role_name}"
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.seed_tfstate_bucket}/*"
    }
  ]
}
EOF
}

output "internal_role_arn" {
  value = "${module.internal.role_arn}"
}

output "internal_account_id" {
  value = "${module.internal.account_id}"
}

output "internal_tfstate_bucket" {
  value = "${module.internal.tfstate_bucket}"
}

output "internal_tfstate_bucket_arn" {
  value = "${module.internal.tfstate_bucket_arn}"
}

output "seed_tfstate_bucket" {
  value = "${var.seed_tfstate_bucket}"
}

output "seed_tfstate_bucket_arn" {
  value = "arn:aws:s3:::${var.seed_tfstate_bucket}"
}
