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
