# Lab 4 AWS automation design

- Region: us-east-1.
- Reuse the existing account-level GitHub OIDC provider.
- Create dedicated Lab 4 Terraform plan and apply roles.
- Restrict role trust to the intended Lab 4 repository and approved context.
- Store pipeline Terraform state in a dedicated S3 backend with locking.
- Run Terraform checks and plan in GitHub Actions for pull requests.
- Run apply through a protected GitHub deployment workflow after merge.
- Keep AWS long-lived credentials out of GitHub.
- Define the one-time bootstrap in Terraform and review its plan before applying.
- Determine the repository's actual GitHub OIDC subject before finalizing trust.

## Verified OIDC subject

The diagnostic workflow on `master`, without a GitHub environment, reported:

`repo:DelaneKay@59389630/project-4-secure-software-supply-chain@1453914726:ref:refs/heads/master`

Pull request and GitHub environment contexts produce different subjects. Verify each intended context before using it in an IAM trust policy. Never print or store the OIDC token.
