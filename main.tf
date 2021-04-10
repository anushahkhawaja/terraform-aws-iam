terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

data "aws_iam_policy_document" "s3_assume_role_policy" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "s3_admin_permission" {

  statement {
    actions = ["s3:*",]
    resources = ["*"]
  }
}

resource "aws_iam_role" "ec2_s3_admin_role" {

  name        = "s3_admin_role"
  description = "Role with s3 admin permissions"

  assume_role_policy = data.aws_iam_policy_document.s3_assume_role_policy.json
}

resource "aws_iam_policy" "s3_admin_policy" {

  name = "s3_admin_policy"
  description = "Grant access to all s3 resources"

  policy = data.aws_iam_policy_document.s3_admin_permission.json

}

resource "aws_iam_role_policy_attachment" "s3_admin_policy_attachment" {
  role = aws_iam_role.ec2_s3_admin_role.name
  policy_arn = aws_iam_policy.s3_admin_policy.arn
  
}

