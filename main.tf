# Local Variables
locals {
  env = terraform.workspace
}

## VPC Module
module "vpc-module" {
  source     = "./modules/vpc-module"
  aws_region = var.aws_region
  vpc_enable_nat_gateway = var.vpc_enable_nat_gateway
  allow_jenkins_http     = true   # Training: open Jenkins UI on port 8080
  jenkins_http_cidr      = "0.0.0.0/0" # Consider restricting to your IP/32
  # aws_instance_id      = module.jenkins-module.aws_instance_id #var.aws_instance_id
  public_subnet_id     = var.public_subnet_id #module.public_subnet_id
  network_interface_id = var.network_interface_id
  vpc_name             = var.vpc_name
  vpc_cidr_block       = var.vpc_cidr_block
  availability_zones   = var.availability_zones
  public_subnet_cidr   = var.public_subnet_cidr  # ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr  = var.private_subnet_cidr # ["10.0.3.0/24", "10.0.4.0/24"]
}

### EKS-Cluster Requirement  --- Below 
## EKS Module
module "eks-module" {
  source                  = "./modules/eks-module"
  aws_region              = var.aws_region
  cluster_name            = var.cluster_name
  vpc_id                  = module.vpc-module.vpc_id
  private_subnet_ids      = module.vpc-module.private_subnet_ids
  public_subnet_ids       = module.vpc-module.public_subnet_ids
  node_group_desired_size = var.node_group_desired_size
  node_group_min_size     = var.node_group_min_size
  node_group_max_size     = var.node_group_max_size
  use_public_subnets_for_nodes = var.vpc_enable_nat_gateway ? false : true
  # providers = {
  #   kubectl = kubectl
  # }
}


### EKS-Cluster Requirement  --- Above 

## Note: Jenkins, ArgoCD, and Monitoring moved to separate stacks under stacks/.
