module "jenkins2_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.9.1"

  name = "jenkins_vpc_${var.product}-${var.environment}"

  enable_dns_hostnames = true
  enable_dns_support   = true

  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_az}"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  # enable_nat_gateway = true
  # single_nat_gateway = true

  tags = {
    Environment = "${var.environment}"
    ManagedBy   = "terraform"
    Name        = "jenkins2_vpc_${var.product}_${var.environment}"
    Product     = "${var.product}"
  }
}
