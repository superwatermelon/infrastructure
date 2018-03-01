variable "test_aws_profile" {
  description = "The profile of the test AWS account."
  type        = "string"
}

variable "test_tfstate_bucket" {
  description = "The name of the S3 bucket for test tfstate."
  type        = "string"
}

module "test" {
  source               = "./setup"
  aws_profile          = "${var.test_aws_profile}"
  tfstate_bucket       = "${var.test_tfstate_bucket}"
  principal_arn        = "arn:aws:iam::${data.aws_caller_identity.internal.account_id}:root"
  admin_role_name      = "admin-test"
  deployment_role_name = "deployment-test"
  ecr_role_name        = "ecr-test"
}

output "test_admin_role_arn" {
  value = "${module.test.admin_role_arn}"
}

output "test_deployment_role_arn" {
  value = "${module.test.deployment_role_arn}"
}

output "test_ecr_role_arn" {
  value = "${module.test.ecr_role_arn}"
}

output "test_account_id" {
  value = "${module.test.account_id}"
}

output "test_tfstate_bucket" {
  value = "${module.test.tfstate_bucket}"
}

output "test_tfstate_bucket_arn" {
  value = "${module.test.tfstate_bucket_arn}"
}
