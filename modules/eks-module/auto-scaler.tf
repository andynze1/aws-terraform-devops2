# EKS Cluster Autoscaler Helm Release
resource "helm_release" "cluster_autoscaler" {
  count      = var.enable_cluster_autoscaler ? 1 : 0
  name       = "${var.cluster_name}-cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
 # version    = "9.13.0" # Example version, ensure compatibility with your k8s version
  namespace  = "kube-system"
  values = [
    yamlencode({
      rbac = {
        serviceAccount = {
          name = "cluster-autoscaler"
          annotations = {
            "eks.amazonaws.com/role-arn" = aws_iam_role.eks_cluster_autoscaler[0].arn
          }
        }
      }
    })
  ]
  depends_on = [module.eks]  # Updated dependency to wait for the EKS module
}
