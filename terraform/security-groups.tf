module "jenkins2_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "1.22.0"

  name        = "jenkins2_sg_${var.product}_${var.environment}"
  description = "Jenkins2 Security Group Allowing HTTP and SSH"
  vpc_id      = "${module.jenkins2_vpc.vpc_id}"

  ingress_cidr_blocks = ["${var.allowed_ips}"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp", "all-icmp", "ssh-tcp"]
  egress_rules        = ["all-all"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 50000
      to_port     = 50000
      protocol    = "tcp"
      description = "Docker hosts talking back to master"
      cidr_blocks = "${module.jenkins2_worker.private_ip}/32"
    },
    {
      from_port   = 2375
      to_port     = 2375
      protocol    = "tcp"
      description = "master talking to docker agent"
      cidr_blocks = "10.0.101.0/24"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Docker hosts talking back to master http"
      cidr_blocks = "${module.jenkins2_worker.private_ip}/32"
    },
  ]
}

module "jenkins2_security_group_cloudflare" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "1.22.0"

  name        = "jenkins2_sg_${var.product}_${var.environment}_cloudflare"
  description = "Jenkins2 Security Group Allowing HTTP and SSH - Cloudflare"
  vpc_id      = "${module.jenkins2_vpc.vpc_id}"

  ingress_cidr_blocks = ["${var.cloudflare_ips}"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}
