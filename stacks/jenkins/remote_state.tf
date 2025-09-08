data "terraform_remote_state" "eks_vpc" {
  backend = "s3"
  config = {
    bucket = "my-terraform-state85"
    key    = "environments2"    # Root eks+vpc state key
    region = "us-east-1"
  }
}

