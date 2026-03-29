module "dashboard_counting_app" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name                 = var.vpc_name
  cidr                 = var.vpc_cidr
  azs                  = var.azs
  enable_dns_hostnames = var.enable_dns_hostnames

  public_subnets      = var.public_subnets
  public_subnet_tags  = var.public_subnet_tags
  private_subnets     = var.private_subnets
  private_subnet_tags = var.private_subnet_tags
  enable_nat_gateway  = var.enable_nat_gateway
  single_nat_gateway  = var.single_nat_gateway
}

module "dashboard_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name                     = var.dashboard_sg_name
  vpc_id                   = module.dashboard_counting_app.vpc_id
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  egress_with_cidr_blocks  = var.egress_with_cidr_blocks
}

module "counting_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name   = var.counting_sg_name
  vpc_id = module.dashboard_counting_app.vpc_id
  ingress_with_source_security_group_id = [
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      source_security_group_id = module.dashboard_sg.security_group_id
    },
    {
      from_port                = 8888
      to_port                  = 8888
      protocol                 = "tcp"
      source_security_group_id = module.dashboard_sg.security_group_id
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

}

