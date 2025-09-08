locals {
  oidc_provider_hostpath = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
}

# IAM Role for AWS Load Balancer Controller (IRSA)
resource "aws_iam_role" "aws_load_balancer_controller_role" {
  count = var.enable_aws_load_balancer_controller ? 1 : 0
  name  = "${var.cluster_name}-aws-load-balancer-controller-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = module.eks.oidc_provider_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_provider_hostpath}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "aws_load_balancer_controller_policy" {
  count  = var.enable_aws_load_balancer_controller ? 1 : 0
  name   = "${var.cluster_name}-eks-load-balancer-controller-policy"
  role   = aws_iam_role.aws_load_balancer_controller_role[0].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "elasticloadbalancing:*",
          "iam:CreateServiceLinkedRole",
          "iam:GetServerCertificate",
          "iam:ListServerCertificates",
          "cognito-idp:DescribeUserPoolClient",
          "acm:ListCertificates",
          "acm:DescribeCertificate",
          "waf-regional:GetWebACLForResource",
          "waf-regional:GetWebACL",
          "waf-regional:AssociateWebACL",
          "waf-regional:DisassociateWebACL",
          "tag:GetResources",
          "tag:TagResources",
          "waf:GetWebACL",
          "waf:AssociateWebACL",
          "waf:DisassociateWebACL"
        ],
        Resource = "*"
      }
    ]
  })
}

# Helm release for AWS Load Balancer Controller
resource "helm_release" "aws_load_balancer_controller" {
  count      = var.enable_aws_load_balancer_controller ? 1 : 0
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.4.4"
  set {
    name  = "replicaCount"
    value = 1
  }
  set {
    name  = "clusterName"
    value = module.eks.cluster_name  # Updated reference
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws_load_balancer_controller_role[0].arn
  }
  depends_on = [module.eks]
}
