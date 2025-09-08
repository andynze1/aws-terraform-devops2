variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "ssh_ingress_cidr" {
  type        = string
  description = "CIDR allowed to SSH/HTTP to Jenkins (use your_ip/32)"
  default     = "0.0.0.0/0"
}
