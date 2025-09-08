locals {
  # Unified VPC Configuration
  vpc_name       = var.vpc_name
  cidr_block     = var.vpc_cidr_block  # Single CIDR block for the VPC

  # Security group rules: SSH from your IP only
  security_group_rules = [
    {
      name        = "SSH access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.my_ip_address]
    }
  ]
}
