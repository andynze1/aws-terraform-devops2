module "jenkins-module" {
  source               = "../../modules/jenkins-module"
  public_subnet_id     = data.terraform_remote_state.eks_vpc.outputs.public_subnet_ids[0]
  private_subnet_id    = data.terraform_remote_state.eks_vpc.outputs.private_subnet_ids[0]
  vpc_id               = data.terraform_remote_state.eks_vpc.outputs.vpc_id
  security_group_id    = data.terraform_remote_state.eks_vpc.outputs.security_group_id
  network_interface_id = ""
}
