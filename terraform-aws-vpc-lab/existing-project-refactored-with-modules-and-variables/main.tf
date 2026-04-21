module "network" {
  source = "./modules/network"

  vpc_cidr = var.vpc_cidr
  vpc_name            = var.vpc_name
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  az = var.az

}

module "compute" {
  source = "./modules/compute"

  vpc_id = module.network.vpc_id
  private_subnet = module.network.private_subnet_id
  vm_type = var.vm_type
}