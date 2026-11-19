locals {
  github_oidc_provider = "token.actions.githubusercontent.com"

  github_apply_subject = "repo:DelaneKay@59389630/project-4-secure-software-supply-chain@1453914726:environment:lab4-apply"
}

data "aws_iam_policy_document" "github_apply_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.github_oidc_provider}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.github_oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.github_oidc_provider}:sub"
      values   = [local.github_apply_subject]
    }
  }
}

resource "aws_iam_role" "github_apply" {
  name               = "project-4-terraform-apply-role"
  assume_role_policy = data.aws_iam_policy_document.github_apply_trust.json

  tags = {
    Project = "devsecops-lab-4"
    Purpose = "terraform-apply"
  }
}
