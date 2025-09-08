# Install AWS EBS CSI Driver using Helm
# Create a StorageClass that uses the AWS EBS CSI Driver
resource "kubernetes_storage_class_v1" "ebs_sc" {
  metadata {
    name = "ebs-sc"
  }
  storage_provisioner  = "ebs.csi.aws.com"
  reclaim_policy       = "Delete"
  volume_binding_mode  = "WaitForFirstConsumer"
  parameters = {
    type = "gp2"
  }
  depends_on = [module.eks]  # Ensure the cluster and addon are ready
}
