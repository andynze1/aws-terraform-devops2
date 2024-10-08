resource "helm_release" "argo_cd" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = kubernetes_namespace.argocd.id
  create_namespace = false
  skip_crds        = true
  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "server.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"  # or "alb"
  }

  set {
    name  = "server.service.selector.app\\.kubernetes\\.io/instance"
    value = "argo-cd"
  }
  set {
    name  = "server.ingress.enabled"
    value = "false"
  }
  set {
    name  = "server.service.selector.app\\.kubernetes\\.io/name"
    value = "argocd-server"
  }
  # set {
  #   name  = "server.serviceAccount.name"
  #   value = kubernetes_service_account.argocd.metadata[0].name
  # }
  depends_on = [
    module.eks,
    kubernetes_namespace.argocd,
    # aws_lb.argocd,
    # aws_route53_record.argocd
  ]
}

