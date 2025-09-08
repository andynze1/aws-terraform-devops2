module "argocd-module" {
  source       = "../../modules/argocd-module"
  aws_region   = var.aws_region
  cluster_name = data.terraform_remote_state.eks_vpc.outputs.eks_cluster_name
  providers = {
    kubernetes = kubernetes.eks
    helm       = helm.eks
  }
}

