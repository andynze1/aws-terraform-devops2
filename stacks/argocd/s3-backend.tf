terraform {
  backend "s3" {
    bucket = "my-terraform-state85"
    key    = "argocd/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}

