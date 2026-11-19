# Bootstrap state procedure

## Purpose

The bootstrap creates the Lab 4 Terraform state bucket and initial GitHub
OIDC apply role. Its own state starts locally because the bucket does not yet
exist. After creation, migrate that state to the same protected bucket under
a separate key:

- Bootstrap state: `bootstrap/terraform.tfstate`
- Foundation state: `foundation/terraform.tfstate`

## Before the first apply

1. Review the bootstrap Terraform configuration and a fresh plan.
2. Confirm the `lab4-apply` GitHub environment is restricted to `master`.
3. Confirm the bootstrap operator can manage the planned S3 and IAM resources.
4. Ensure local state is ignored by Git and stored in the WSL user's private
   directory. Terraform state and saved plans can contain sensitive data.
5. Decide where to retain a protected recovery copy of the initial local state.

## After the first apply

1. Confirm the bucket exists, versioning is enabled, default encryption is
   configured, and public access is blocked.
2. Restrict access to the local bootstrap state file and make a protected
   recovery copy outside the repository.
3. Add and review an S3 backend configuration for the bootstrap, using the
   bootstrap state key and S3 lockfile.
4. Run `terraform init -migrate-state` with the bootstrap operator's AWS
   credentials and the actual bucket name.
5. Verify Terraform can read the migrated state and that a fresh plan does
   not propose recreating the bootstrap resources.
6. Retain the recovery copy securely. Do not commit state, plans, or
   credentials.

The bootstrap state is managed separately from the application foundation.
The GitHub apply role's existing policy grants access only to the foundation
state key, not the bootstrap state key.

## Cleanup

The state bucket has `prevent_destroy` enabled. Destroying the application
foundation does not remove the bootstrap. Remove retained state and bootstrap
resources only through a separately reviewed cleanup procedure.
