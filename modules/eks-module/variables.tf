variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
# variable "subnet_ids" {
#   description = "A list of subnet IDs for the EKS cluster"
#   type        = list(string)
# }

variable "business_division" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "dml"
}
variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "dml-eks-cluster"
}


variable "node_instance_type" {
  description = "The instance type for the EKS node group."
  type        = string
  default     = "t3.medium"
}

variable "node_capacity_type" {
  description = "The node type for the EKS node group."
  type        = string
  default     = "ON_DEMAND"
}

variable "node_group_desired_size" {
  description = "Desired size of the node group"
  type        = number
  default     = 2
}

variable "node_group_max_size" {
  description = "Maximum size of the node group"
  type        = number
  default     = 3
}

variable "node_group_min_size" {
  description = "Minimum size of the node group"
  type        = number
  default     = 1
}

# AWS Account ID
variable "aws_account_id" {
  description = "AWS User Account ID"
  type        = string
  default     = "778805653184"
}

# AWS Account Name
variable "aws_account_name" {
  description = "AWS User Account name"
  type        = string
  default     = "andy"
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. When it's set to `false` ensure to have a proper private access with `cluster_endpoint_private_access = true`."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file."
  type        = string
  default     = "~/.kube/config"
}

# variable "kube-namespace" {
#   description = "Kubernetes namespace to deploy the AWS Load Balancer Controller into."
#   type        = string
#   default     = "kube-system"
# }

variable "grafana_admin_password" {
  description = "Admin password for Grafana."
  type        = string
  default     = "password"
}

variable "iam_username" {
  type = string
  default = "admin"
}

variable "iam_role_name" {
  type = string
  default = "eks_user_role"
}

variable "ssh_key_name" {
  description = "Key pair for EC2 access"
  type        = string
  default     = "eks-terraform-key"
}

# Feature flags to optionally enable components
variable "enable_monitoring" {
  description = "Deploy Prometheus and Grafana"
  type        = bool
  default     = false
}

variable "enable_gitops" {
  description = "Deploy ArgoCD"
  type        = bool
  default     = false
}

variable "enable_cert_manager" {
  description = "Deploy cert-manager"
  type        = bool
  default     = false
}

variable "enable_aws_load_balancer_controller" {
  description = "Deploy AWS Load Balancer Controller"
  type        = bool
  default     = true
}

variable "enable_cluster_autoscaler" {
  description = "Deploy Cluster Autoscaler"
  type        = bool
  default     = false
}

# Backward-compat shim: allow passing node group defaults at root without requiring it
variable "eks_managed_node_group_defaults" {
  description = "Optional defaults for EKS managed node groups (unused shim)."
  type = object({
    ami_type   = string
    disk_size  = number
    iam_role_arn = optional(string)
  })
  default = {
    ami_type  = "AL2_x86_64"
    disk_size = 10
  }
}

# EKS Kubernetes version
variable "cluster_version" {
  description = "Kubernetes version for the EKS control plane"
  type        = string
  default     = "1.33"
}

variable "use_public_subnets_for_nodes" {
  description = "Place node groups in public subnets (set true when NAT is disabled)"
  type        = bool
  default     = false
}

variable "enable_kubeconfig_update" {
  description = "If true, run a local-exec to update kubeconfig and wait for API readiness."
  type        = bool
  default     = false
}
