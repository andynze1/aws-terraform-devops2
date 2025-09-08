variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  default     = "password"
}

variable "create_storage_class" {
  description = "Whether to create an EBS-backed StorageClass 'ebs-sc'"
  type        = bool
  default     = false
}
