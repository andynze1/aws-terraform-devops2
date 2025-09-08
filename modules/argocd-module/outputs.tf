output "argo_cd_helm_metadata" {
  description = "Metadata for ArgoCD Helm release"
  value       = helm_release.argo_cd.metadata
}

output "argocd_lb_hostname" {
  description = "ArgoCD Server LoadBalancer hostname"
  value       = try(data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].hostname, null)
}

output "argocd_url" {
  description = "Convenience URL for ArgoCD"
  value       = try(
    format("https://%s", data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].hostname),
    null
  )
}
