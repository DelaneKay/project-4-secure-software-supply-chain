data "aws_partition" "current" {}

locals {
  foundation_state_key = "foundation/terraform.tfstate"

  ecr_repository_arn = "arn:${data.aws_partition.current.partition}:ecr:us-east-1:${data.aws_caller_identity.current.account_id}:repository/lab4-juice-shop"
}

data "aws_iam_policy_document" "github_apply_permissions" {
  statement {
    sid       = "ListFoundationState"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.terraform_state.arn]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["foundation/*"]
    }
  }

  statement {
    sid    = "ReadWriteFoundationState"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.terraform_state.arn}/${local.foundation_state_key}"
    ]
  }

  statement {
    sid    = "ManageFoundationLock"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${aws_s3_bucket.terraform_state.arn}/${local.foundation_state_key}.tflock"
    ]
  }

  statement {
    sid       = "DescribeRepositories"
    effect    = "Allow"
    actions   = ["ecr:DescribeRepositories"]
    resources = ["*"]
  }

  statement {
    sid    = "ManageLabRepository"
    effect = "Allow"
    actions = [
      "ecr:CreateRepository",
      "ecr:DeleteRepository",
      "ecr:DescribeImages",
      "ecr:ListTagsForResource",
      "ecr:PutImageScanningConfiguration",
      "ecr:PutImageTagMutability",
      "ecr:TagResource",
      "ecr:UntagResource"
    ]
    resources = [local.ecr_repository_arn]
  }
}

resource "aws_iam_role_policy" "github_apply" {
  name   = "lab4-foundation-terraform"
  role   = aws_iam_role.github_apply.id
  policy = data.aws_iam_policy_document.github_apply_permissions.json
}
