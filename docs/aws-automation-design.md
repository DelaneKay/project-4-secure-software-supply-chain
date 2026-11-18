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
