locals {
  owners      = var.business_division
  name        = "${var.business_division}-${var.cluster_name}"
  common_tags = {
    owners      = local.owners  }
  eks_name = var.cluster_name
}

# Removed duplicate variable declaration of cluster_name
