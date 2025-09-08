# EKS Cluster module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.24"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnet_ids
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  # cluster_endpoint_private_access = var.cluster_endpoint_private_access

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_group_defaults = {
    # AL2 is unsupported for Kubernetes >= 1.33; use AL2023
    ami_type  = "AL2023_x86_64_STANDARD"
    disk_size = 30
  }

  enable_irsa = true

  # Avoid attempting to create a CloudWatch log group if it already exists
  create_cloudwatch_log_group = false

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    public_nodes = {
      name               = "default-node-group"
      instance_types     = [var.node_instance_type]
      desired_size       = var.node_group_desired_size
      min_size           = var.node_group_min_size
      max_size           = var.node_group_max_size
      capacity_type      = var.node_capacity_type
      subnet_ids         = var.use_public_subnets_for_nodes ? var.public_subnet_ids : var.private_subnet_ids
      key_name           = var.ssh_key_name
      labels = {
        role = "general"
      }
    }
  }

  tags = {
    Environment = "dev"
  }
}
