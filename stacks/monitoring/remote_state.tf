data "terraform_remote_state" "eks_vpc" {
  backend = "s3"
  config = {
    bucket = "my-terraform-state85"
    key    = "environments2"   # Root eks+vpc state key
    region = "us-east-1"
  }
}

data "aws_eks_cluster" "eks" {
  name = data.terraform_remote_state.eks_vpc.outputs.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = data.terraform_remote_state.eks_vpc.outputs.eks_cluster_name
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  alias = "eks"
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}
