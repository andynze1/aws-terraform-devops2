# Output the EKS cluster details
output "eks_cluster_id" {
  description = "The ID of the EKS cluster"
  value       = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = module.eks.cluster_arn
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

# Removing or adjusting the node group ID output if not available
output "aws_load_balancer_controller_role_arn" {
  value = var.enable_aws_load_balancer_controller ? aws_iam_role.aws_load_balancer_controller_role[0].arn : null
}

output "eks_cluster_autoscaler_arn" {
  value = var.enable_cluster_autoscaler ? aws_iam_role.eks_cluster_autoscaler[0].arn : null
}

output "oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "prometheus_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value       = var.enable_monitoring ? helm_release.prometheus[0].status : null
}

output "grafana_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value       = var.enable_monitoring ? helm_release.grafana[0].metadata : null
}

output "argo_cd_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value       = var.enable_gitops ? helm_release.argo_cd[0].metadata : null
}

# Which subnets are used for the node group
output "node_subnet_type" {
  description = "Indicates whether node group uses public or private subnets"
  value       = var.use_public_subnets_for_nodes ? "public" : "private"
}

output "node_subnet_ids" {
  description = "The subnet IDs used by the node group"
  value       = var.use_public_subnets_for_nodes ? var.public_subnet_ids : var.private_subnet_ids
}
