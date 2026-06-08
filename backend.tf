terraform {
  backend "s3" {
    bucket         = "tf-state-myapp-825347768470"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
