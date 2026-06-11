terraform {
  backend "s3" {
    bucket       = "tf-state-myapp-825347768470"
    key          = "infra/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
