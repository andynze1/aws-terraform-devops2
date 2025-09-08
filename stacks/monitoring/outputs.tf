output "prometheus_helm_metadata" {
  description = "Prometheus Helm release metadata"
  value       = module.monitoring-module.prometheus_helm_metadata
}

output "grafana_helm_metadata" {
  description = "Grafana Helm release metadata"
  value       = module.monitoring-module.grafana_helm_metadata
}

## Grafana exposed as ClusterIP to avoid extra LBs. Use port-forward or an Ingress.
