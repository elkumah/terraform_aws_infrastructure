# Terraform AWS Infrastructure

Reusable Terraform modules for deploying a standard AWS infrastructure stack — VPC, EC2, and S3 — with environment isolation via Terraform workspaces.

## Architecture

This project provisions:

- **VPC** — public and private subnets across two availability zones, an Internet Gateway, route tables, and an optional NAT Gateway
- **EC2** — an Ubuntu instance with a configurable security group, encrypted root volume, and IMDSv2 enforced
- **S3** — a secured bucket with versioning, AES-256 encryption, public access blocked, and optional lifecycle rules

## Modules

| Module                       | Description                                      |
| ---------------------------- | ------------------------------------------------ |
| [modules/vpc](./modules/vpc) | Networking layer — VPC, subnets, routing         |
| [modules/ec2](./modules/ec2) | Compute layer — EC2 instance and security group  |
| [modules/s3](./modules/s3)   | Storage layer — S3 bucket with security defaults |

## Requirements

| Name         | Version   |
| ------------ | --------- |
| Terraform    | >= 1.10.0 |
| AWS Provider | ~> 5.0    |

## Getting Started

### 1. Configure the backend

This project uses an S3 backend with native locking (`use_lockfile`). Update `backend.tf` with your own state bucket:

```hcl
terraform {
  backend "s3" {
    bucket       = "your-tf-state-bucket"
    key          = "infra/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

### 2. Initialize and create workspaces

```bash
terraform init
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```

### 3. Deploy an environment

Each environment has its own `.tfvars` file under `envs/`:

```bash
terraform workspace select dev
terraform plan  -var-file=envs/dev.tfvars
terraform apply -var-file=envs/dev.tfvars
```

The same commands with a different workspace and `.tfvars` file deploy an identical stack to staging or prod, fully isolated.

### 4. Destroy an environment

```bash
terraform destroy -var-file=envs/dev.tfvars
```

## Environments

| Environment | VPC CIDR    | Instance Type | NAT Gateway | Versioning |
| ----------- | ----------- | ------------- | ----------- | ---------- |
| dev         | 10.0.0.0/16 | t3.micro      | No          | No         |
| staging     | 10.1.0.0/16 | t3.small      | No          | Yes        |
| prod        | 10.2.0.0/16 | t3.large      | Yes         | Yes        |

## CI/CD

Every push and pull request to `main` triggers a GitHub Actions workflow (`.github/workflows/terraform.yml`) that runs `terraform fmt -check`, `terraform validate`, and `terraform plan` against the `dev` workspace, authenticating to AWS via OIDC — no stored credentials.

## Examples

Each module includes a standalone usage example under [`examples/`](./examples), which can be run independently to test the module in isolation:

```bash
cd examples/vpc
terraform init
terraform plan
terraform apply
terraform destroy
```

## Project Structure

.
├── backend.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── envs/
│ ├── dev.tfvars
│ ├── staging.tfvars
│ └── prod.tfvars
├── modules/
│ ├── vpc/
│ ├── ec2/
│ └── s3/
└── examples/
├── vpc/
├── ec2/
└── s3/

## Project Notes

For a write-up on why this project was built this way, lessons learned, and real challenges encountered during development, see [PROJECT_NOTES.md](./PROJECT_NOTES.md).

## License

MIT
