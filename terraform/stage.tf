variable "stage_aws_profile" {
  description = "The profile of the stage AWS account."
  type        = "string"
}

variable "stage_tfstate_bucket" {
  description = "The name of the S3 bucket for stage tfstate."
  type        = "string"
}

module "stage" {
  source               = "./setup"
  aws_profile          = "${var.stage_aws_profile}"
  tfstate_bucket       = "${var.stage_tfstate_bucket}"
  principal_arn        = "arn:aws:iam::${data.aws_caller_identity.internal.account_id}:root"
  deployment_role_name = "deployment-stage"
}

output "stage_role_arn" {
  value = "${module.stage.role_arn}"
}

output "stage_account_id" {
  value = "${module.stage.account_id}"
}

output "stage_tfstate_bucket" {
  value = "${module.stage.tfstate_bucket}"
}

output "stage_tfstate_bucket_arn" {
  value = "${module.stage.tfstate_bucket_arn}"
}