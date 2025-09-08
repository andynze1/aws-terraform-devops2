# output "build_server_ip" {
#   value = module.vm-module.build_server_ip
# }

## EKS-Cluster Requirement  --- Below 
# output "aws_load_balancer_controller_role_arn" {
#   description = "AWS Load Balancer Controller Role ARN"
#   value       = module.eks-module.aws_load_balancer_controller_role_arn
# }

output "prometheus_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value       = module.eks-module.prometheus_helm_metadata
}

output "grafana_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value       = module.eks-module.grafana_helm_metadata
}

output "argo_cd_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value       = module.eks-module.argo_cd_helm_metadata
}
## EKS-Cluster Requirement  --- Above 

output "oidc_issuer_url" {
  value = module.eks-module.oidc_issuer_url
}


output "aws_load_balancer_controller_role_arn" {
  description = "AWS Load Balancer Controller Role ARN"
  value       = module.eks-module.aws_load_balancer_controller_role_arn
}

output "node_subnet_type" {
  description = "Indicates whether node group uses public or private subnets"
  value       = module.eks-module.node_subnet_type
}

output "node_subnet_ids" {
  description = "The subnet IDs used by the node group"
  value       = module.eks-module.node_subnet_ids
}


# output "eks_cluster_autoscaler_arn" {
#   value = aws_iam_role.eks_cluster_autoscaler.arn
# }
