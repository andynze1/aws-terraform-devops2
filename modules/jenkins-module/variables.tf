variable "public_subnet_id" {
  type        = string
  description = "Public subnet ID for the Jenkins EC2 instance"
}

variable "private_subnet_id" {
  type        = string
  description = "Private subnet ID (unused by default)"
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID for the instance"
  type        = string
}

variable "network_interface_id" {
  description = "Network Interface ID (optional)"
  type        = string
  default     = ""
}

variable "ami_id_ubuntu" {
  description = "AMI ID for Ubuntu"
  type        = string
  default     = "ami-0a0e5d9c7acc336f1"
}

variable "instance_type" {
  description = "Type of the instance"
  type        = string
  default     = "t3.large"
}

variable "name" {
  type        = string
  description = "Name prefix for the instance"
  default     = "jenkins"
}

variable "linux-keypair" {
  type        = string
  description = "Base name for the SSH key pair"
  default     = "linux-key"
}
