resource "kubernetes_namespace" "argocd" {
  metadata { name = "argocd" }
}

resource "helm_release" "argo_cd" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = kubernetes_namespace.argocd.metadata[0].name
  create_namespace = false
  skip_crds        = true

  set = [
    {
      name  = "server.service.type"
      value = "LoadBalancer"
    },
    {
      name  = "server.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
      value = "nlb"
    },
    {
      name  = "server.service.selector.app\\.kubernetes\\.io/instance"
      value = "argo-cd"
    },
    {
      name  = "server.ingress.enabled"
      value = "false"
    },
    {
      name  = "server.service.selector.app\\.kubernetes\\.io/name"
      value = "argocd-server"
    }
  ]

  depends_on = [kubernetes_namespace.argocd]
}

# Wait briefly for the external load balancer to be provisioned
resource "time_sleep" "wait_for_lb" {
  create_duration = "45s"
  depends_on      = [helm_release.argo_cd]
}

data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argo-cd-argocd-server"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }
  depends_on = [time_sleep.wait_for_lb]
}
