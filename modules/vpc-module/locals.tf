locals {
  # Unified VPC Configuration
  vpc_name   = var.vpc_name
  cidr_block = var.vpc_cidr_block  # Single CIDR block for the VPC

  # Base security group rules: SSH from your IP only
  base_sg_rules = [
    {
      name        = "SSH access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.my_ip_address]
    }
  ]

  # Optional Jenkins UI rule on port 8080
  jenkins_rules = var.allow_jenkins_http ? [
    {
      name        = "Jenkins 8080"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = [var.jenkins_http_cidr]
    }
  ] : []

  security_group_rules = concat(local.base_sg_rules, local.jenkins_rules)
}
