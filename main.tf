provider "aws" {
  region  = var.region
  profile = var.environment
}

module "vpc_setup" {
  source = "./modules/vpcSetup"

  cidr_block            = var.vpc_cidr_block
  instance_tenancy      = var.vpc_instance_tenancy
  subnet_count          = var.subnet_count
  bits                  = var.subnet_bits
  vpc_name              = var.vpc_name
  internet_gateway_name = var.vpc_internet_gateway_name
  public_subnet_name    = var.vpc_public_subnet_name
  public_rt_name        = var.vpc_public_rt_name
  private_subnet_name   = var.vpc_private_subnet_name
  private_rt_name       = var.vpc_private_rt_name
}

module "sec_group_setup" {
  source = "./modules/securityGroup"

  vpc_id = module.vpc_setup.vpc_id
}

module "jenkins_server" {
  source = "./modules/instanceCreate"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  ami_key_pair_name = var.ami_key_pair_name
  subnet_ids        = module.vpc_setup.subnet_ids
  sec_id            = module.sec_group_setup.sec_group_id
  volume_size       = var.volume_size
  volume_type       = var.volume_type
}

module "elastic_ip" {
  source = "./modules/ElasticIP"

  jenkins_server_id = module.jenkins_server.jenkins_server_id
  zone_id           = var.zone_id
  rec_name          = var.rec_name
}
