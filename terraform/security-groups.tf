module "jenkins2_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "1.22.0"

  name        = "jenkins2_sg_${var.product}_${var.environment}"
  description = "Jenkins2 Security Group Allowing HTTP and SSH"
  vpc_id      = "${module.jenkins2_vpc.vpc_id}"

  ingress_cidr_blocks = ["${var.allowed_ips}"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp", "all-icmp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}
