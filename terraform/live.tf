variable "live_aws_profile" {
  description = "The profile of the live AWS account."
  type        = "string"
}

variable "live_tfstate_bucket" {
  description = "The name of the S3 bucket for live tfstate."
  type        = "string"
}

module "live" {
  source               = "./setup"
  aws_profile          = "${var.live_aws_profile}"
  tfstate_bucket       = "${var.live_tfstate_bucket}"
  principal_arn        = "arn:aws:iam::${data.aws_caller_identity.internal.account_id}:root"
  deployment_role_name = "deployment-live"
}

output "live_role_arn" {
  value = "${module.live.role_arn}"
}

output "live_account_id" {
  value = "${module.live.account_id}"
}

output "live_tfstate_bucket" {
  value = "${module.live.tfstate_bucket}"
}

output "live_tfstate_bucket_arn" {
  value = "${module.live.tfstate_bucket_arn}"
}
