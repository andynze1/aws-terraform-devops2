# output "build_server_ip" {
#   value = module.vm-module.build_server_ip
# }

## EKS-Cluster Requirement  --- Below 
# output "aws_load_balancer_controller_role_arn" {
#   description = "AWS Load Balancer Controller Role ARN"
#   value       = module.eks-module.aws_load_balancer_controller_role_arn
# }

## App stack outputs (monitoring/argocd) moved to their own stacks
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

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks-module.eks_cluster_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc-module.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc-module.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc-module.private_subnet_ids
}

output "security_group_id" {
  description = "Default security group ID"
  value       = module.vpc-module.security_group_id
}


# output "eks_cluster_autoscaler_arn" {
#   value = aws_iam_role.eks_cluster_autoscaler.arn
# }
