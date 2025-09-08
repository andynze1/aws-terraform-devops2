module "monitoring-module" {
  source                 = "../../modules/monitoring-module"
  aws_region             = var.aws_region
  cluster_name           = data.terraform_remote_state.eks_vpc.outputs.eks_cluster_name
  grafana_admin_password = "admin"
  providers = {
    kubernetes = kubernetes.eks
    helm       = helm.eks
  }
}

