resource "kubernetes_namespace" "monitoring" {
  metadata { name = "monitoring" }
}

resource "kubernetes_storage_class_v1" "ebs_sc" {
  count = var.create_storage_class ? 1 : 0
  metadata { name = "ebs-sc" }
  storage_provisioner  = "ebs.csi.aws.com"
  reclaim_policy       = "Delete"
  volume_binding_mode  = "WaitForFirstConsumer"
  parameters = { type = "gp2" }
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = false
  timeout          = 600
  values = [
    file("${path.module}/values/prometheus-values.yaml")
  ]
}

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = false
  wait             = true
  timeout          = 300
  force_update     = true
  values = [
    file("${path.module}/values/grafana-values.yaml")
  ]
  # Expose internally only to avoid extra Load Balancers
  set = [
    {
      name  = "service.type"
      value = "ClusterIP"
    }
  ]
  set_sensitive = [
    {
      name  = "adminPassword"
      value = var.grafana_admin_password
    }
  ]
}


output "prometheus_helm_metadata" {
  description = "Metadata for Prometheus Helm release"
  value       = helm_release.prometheus.metadata
}

output "grafana_helm_metadata" {
  description = "Metadata for Grafana Helm release"
  value       = helm_release.grafana.metadata
}
