variable "principal_arn" {
  description = "Principal ARN of the internal account"
  type        = "string"
}

variable "deployment_role_name" {
  description = "The name of the deployment role"
}

variable "ecr_role_name" {
  description = "The name of the ECR role"
}

data "aws_caller_identity" "user" {
  provider = "aws.${var.aws_profile}"
}

resource "aws_iam_role" "role" {
  provider = "aws.${var.aws_profile}"
  name     = "${var.deployment_role_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "${var.principal_arn}"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_access" {
  provider   = "aws.${var.aws_profile}"
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "route_53_access" {
  provider   = "aws.${var.aws_profile}"
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  provider   = "aws.${var.aws_profile}"
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  provider   = "aws.${var.aws_profile}"
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "rds_access" {
  provider   = "aws.${var.aws_profile}"
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_role_policy" "tfstate_bucket_policy" {
  provider = "aws.${var.aws_profile}"
  name     = "tfstate_bucket_policy"
  role     = "${aws_iam_role.role.name}"
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.tfstate_bucket.arn}/*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecr_role" {
  provider = "aws.${var.aws_profile}"
  name     = "${var.ecr_role_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "${var.principal_arn}"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecr_role_access" {
  provider   = "aws.${var.aws_profile}"
  role       = "${aws_iam_role.ecr_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

output "role_name" {
  value = "${aws_iam_role.role.name}"
}

output "role_arn" {
  value = "${aws_iam_role.role.arn}"
}

output "ecr_role_name" {
  value = "${aws_iam_role.ecr_role.name}"
}

output "ecr_role_arn" {
  value = "${aws_iam_role.ecr_role.arn}"
}

output "account_id" {
  value = "${data.aws_caller_identity.user.account_id}"
}
