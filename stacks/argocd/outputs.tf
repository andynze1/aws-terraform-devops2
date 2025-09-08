output "argocd_helm_metadata" {
  description = "ArgoCD Helm release metadata"
  value       = module.argocd-module.argo_cd_helm_metadata
}

output "argocd_lb_hostname" {
  description = "ArgoCD Server LB hostname"
  value       = module.argocd-module.argocd_lb_hostname
}

output "argocd_url" {
  description = "ArgoCD URL"
  value       = module.argocd-module.argocd_url
}

