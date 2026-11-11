# Lab 4 Source of Truth: Secure Software Supply Chain

**Status:** Agreed lab scope. Use this document as the project baseline. Do not change scope without the owner's consent. Explain technical issues and propose corrections before changing the baseline.

## Objective

Build OWASP Juice Shop from pinned source through GitHub Actions, produce and verify evidence for the container image, and deploy the verified digest to AWS. Target SLSA Build L2: assess the complete builder and provenance requirements before claiming compliance. SLSA Build L3 is reserved for the capstone.

## Agreed sequence

1. **Fork and pin source:** Fork the official Juice Shop repository, create a lab branch, record the upstream release or commit, and build from that fixed revision. Enable branch protection and Dependabot. Avoid floating latest tags.
2. **AWS and ECR:** Select an AWS region and create a private ECR repository. Configure a GitHub Actions IAM role using OIDC, restricting trust to the intended repository and branch or environment. Grant only necessary ECR permissions. Do not store long-lived AWS access keys in GitHub.
3. **GitHub Actions:** On pull requests run Gitleaks, dependency checks, tests, and an image build and scan. On merges to the protected branch build the release image, generate an SBOM, scan it, and push to ECR. Pin third-party actions to full commit SHAs, use minimal workflow permissions, and a separate deployment environment for release steps.
4. **SBOM:** Generate a CycloneDX or SPDX inventory with Syft. Save it as a workflow artifact and scan it with Grype. Review dependencies and findings; document accepted exceptions with reasons and review dates.
5. **Scan gates:** Use Trivy for image findings and Gitleaks for secrets. Start by failing on high or critical findings with a fix available. Review findings and exceptions. Retain SBOM and scan results with the build record. A successful scan does not prove an image is safe.
6. **Sign and attest:** Use Cosign keyless signing for the ECR image digest with the GitHub Actions OIDC identity and Sigstore's public Fulcio and Rekor services. Generate GitHub provenance and SBOM attestations for that same digest. Record the signature and attestation evidence.
7. **Verify:** Before deployment, require Cosign signature verification against the expected signing identity and OIDC issuer, and verify GitHub provenance and SBOM attestations for the same image digest against the expected repository and workflow identity. If either required verification fails, block deployment. Pass only the verified digest to Terraform, rather than a mutable tag. Restrict AWS deployment permissions to approved paths so the workflow gate cannot be casually bypassed.
8. **Deploy:** Create an ECS Fargate cluster, task definition and service referencing the ECR image digest. Use an execution role for image pulls and logs. Restrict access to this intentionally vulnerable application.
9. **Demonstrate:** Show a successful build and deployment, and demonstrate rejection of a changed digest or an image without the expected attestation. Demonstrate rejection of an unsigned image or unexpected signer as well. Trace the deployed digest through its Cosign signature, SBOM, scan results, attestations, source commit, and workflow run.

## Scope and cost

Use a private or restricted lab, test data, and a short running window. Review AWS costs and delete the service, load balancer if used, and other resources when finished. The supply-chain workflow can be built and verified before creating the AWS service.

## Deliverables

Repository with workflows, SBOM and scan evidence, provenance verification instructions, and a deployment record mapping source commit to deployed image digest. Use branches and pull requests for incremental review as in Lab 3. Do not represent planned controls or evidence as completed.

## References

- https://slsa.dev/spec/v1.2/build-track-basics
- https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws
- https://docs.github.com/en/actions/how-tos/secure-your-work/use-artifact-attestations/use-artifact-attestations
- https://docs.sigstore.dev/cosign/system_config/registry_support/
- https://docs.sigstore.dev/cosign/signing/overview/
- https://docs.aws.amazon.com/AmazonECR/latest/userguide/ECR_on_ECS.html
