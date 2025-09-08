# Resource: k8s monitoring namespace creation
// Monitoring and ArgoCD namespaces moved to dedicated modules

# Resource: k8s dev namespace creation
resource "kubernetes_namespace_v1" "k8s_dev" {
  metadata {
    name = "dev"
  }
}

// Removed time-based delays; rely on provider readiness and Terraform graph
