# Resource: k8s monitoring namespace creation
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

# Resource: k8s argocd namespace creation
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# Resource: k8s dev namespace creation
resource "kubernetes_namespace_v1" "k8s_dev" {
  metadata {
    name = "dev"
  }
}

// Removed time-based delays; rely on provider readiness and Terraform graph
