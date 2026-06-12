## Why This Project

I built this project to deepen my hands-on experience with Terraform beyond single-file configurations and into the patterns used in real production environments: reusable modules, remote state management, multi-environment deployments, and CI/CD automation.

Rather than write one large monolithic configuration, I deliberately structured this as three independent, reusable modules (VPC, EC2, S3)
Each tested in isolation before being wired together into a root module. This mirrors how infrastructure is built and maintained on real teams, where modules are often shared across projects and published for reuse via the Terraform Registry.

The goal was to go beyond "make it work once" and build something that demonstrates: clean module boundaries, environment isolation via workspaces, secure-by-default resource configuration, automated validation through CI/CD, and documentation good enough for someone else to pick up and use.

## Lessons Learned

**Module boundaries matter more than I expected.** Designing the VPC, EC2, and S3 modules to be independently testable — each with its own `examples/` directory — forced me to think carefully about what a module's public interface (its variables and outputs) should look like, versus what should stay as internal implementation detail. This is the same discipline that makes a module worth publishing to a registry: someone else needs to understand it without reading the source.

**Backend configuration is evaluated before everything else.** I learned the hard way that Terraform's `backend` block cannot use variables or interpolation — including `terraform.workspace` — because the backend must be resolved before Terraform knows anything about variables or workspaces. Workspace isolation still works automatically through Terraform's internal `env:/<workspace>/` state key prefixing, but understanding _why_ the backend block has this restriction gave me a much clearer mental model of Terraform's initialization order.

**Environment parity through workspaces + tfvars is genuinely powerful.** Once the root module was wired correctly, deploying an entirely separate staging environment was a single command: switch workspace, point at a different `.tfvars` file. No code changes. Seeing dev and staging exist side by side in AWS — completely isolated state, different CIDR ranges, different instance sizes — made the value of this pattern concrete in a way that reading about it never did.

**OIDC is worth the setup complexity.** Configuring GitHub Actions to authenticate to AWS via OIDC (instead of long-lived access key secrets) took more upfront steps — creating an identity provider, writing a trust policy scoped to my specific repo, creating an IAM role — but the result is a CI/CD pipeline with zero stored AWS credentials. Anyone reviewing the repo's secrets sees nothing sensitive at all.

## Challenges Encountered and How I Fixed Them

**S3 bucket naming failure mid-deployment.** My first full `terraform apply` failed with `InvalidBucketName` because my `project_name` variable contained uppercase letters, and S3 bucket names must be lowercase. Beyond just fixing the variable value, I wrapped the bucket name construction in Terraform's `lower()` function at the source — so this entire class of error becomes structurally impossible going forward, regardless of what gets passed in.

**A stuck `terraform destroy` from an interrupted apply.** After the bucket naming failure, a subsequent destroy hung for over 12 minutes on a security group that AWS refused to delete. I traced this to an EC2 instance from the failed apply that was still in a `running` state — its network interface was still attached to the security group, blocking deletion. I diagnosed this using `aws ec2 describe-network-interfaces` filtered by security group ID, manually terminated the orphaned instance, confirmed the network interface released, and then `terraform plan` resolved cleanly. This taught me that Terraform operations aren't always atomic — partial failures can leave AWS in a state that requires manual reconciliation before Terraform can proceed.

**A variable naming inconsistency that caused an interactive prompt in CI.** During a staging deployment, Terraform unexpectedly prompted for `vpc_cidr` interactively instead of reading it from my `.tfvars` file. I traced this to the module internally using `vpc_cidr_block` as its variable name while my root module's variable was named `vpc_cidr` — a naming mismatch between the module's public interface and how the root module referenced it. Rather than rename across multiple files (and risk reintroducing the bug), I standardized on `vpc_cidr_block` everywhere — module, root, and all environment `.tfvars` files — prioritizing consistency over a cosmetic naming preference.

**Terraform backend deprecation warning.** After setting up the S3 backend with a DynamoDB table for state locking (the traditional approach), `terraform init` returned a deprecation warning for the `dynamodb_table` parameter. I migrated to Terraform's newer `use_lockfile` argument, which uses S3's native conditional-write locking and removes the need for a separate DynamoDB table entirely — one less piece of infrastructure to provision and maintain.

**CI/CD pipeline failures caught real configuration bugs.** My first GitHub Actions run failed because I had set `TF_WORKSPACE` as an environment variable _and_ included an explicit `terraform workspace select` step — Terraform treats `TF_WORKSPACE` as an authoritative override and refuses to let `select` change it. The second failure was a Terraform version mismatch: my backend used `use_lockfile`, a feature requiring Terraform 1.10+, but my workflow specified 1.9.0. Both fixes were small, but they reinforced how valuable an automated `plan` step is — these are exactly the kind of subtle environment-specific issues that are easy to miss when testing only locally.
