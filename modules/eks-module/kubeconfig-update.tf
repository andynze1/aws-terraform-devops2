# Optional local kubeconfig update and API readiness wait

resource "null_resource" "update_kubeconfig" {
  count = var.enable_kubeconfig_update ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      set -euo pipefail
      aws eks update-kubeconfig \
        --name ${module.eks.cluster_name} \
        --region ${var.aws_region} \
        --kubeconfig ${var.kubeconfig_path} \
        --alias ${var.cluster_name}
      # Switch current context to the alias we just set
      kubectl --kubeconfig ${var.kubeconfig_path} config use-context ${var.cluster_name}
    EOT
    interpreter = ["bash", "-c"]
  }

  triggers = {
    cluster_name = module.eks.cluster_name
    region       = var.aws_region
    kubeconfig   = var.kubeconfig_path
  }

  depends_on = [module.eks]
}

resource "null_resource" "wait_for_k8s_api" {
  count = var.enable_kubeconfig_update ? 1 : 0

  provisioner "local-exec" {
    command     = <<-EOT
      set -euo pipefail
      echo "[wait] Checking Kubernetes API readiness"
      for i in $(seq 1 60); do
        if kubectl --kubeconfig ${var.kubeconfig_path} --request-timeout=8s get --raw=/healthz >/dev/null 2>&1; then
          echo "[wait] Kubernetes API is ready"
          exit 0
        fi
        sleep 5
      done
      echo "[wait] Timed out waiting for Kubernetes API"
      exit 1
    EOT
    interpreter = ["bash", "-c"]
  }

  depends_on = [
    module.eks,
    null_resource.update_kubeconfig,
  ]
}
