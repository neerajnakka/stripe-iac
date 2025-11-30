module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs             = ["${var.region}a"]
  public_subnets  = [var.public_subnet_cidr]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Project     = var.project_name
  }
}
