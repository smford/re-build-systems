resource "aws_route53_zone" "private_facing" {
  name   = "${var.environment}.internal"
  vpc_id = "${module.jenkins2_vpc.vpc_id}"

  tags {
    Environment = "${var.environment}"
    ManagedBy   = "terraform"
    Name        = "jenkins2_r53_private_${var.product}_${var.environment}"
    Product     = "${var.product}"
  }
}

resource "aws_route53_zone" "public_facing" {
  name   = "build.gds-reliability.engineering"

  tags {
    Environment = "${var.environment}"
    ManagedBy   = "terraform"
    Name        = "jenkins2_r53_public_${var.product}_${var.environment}"
    Product     = "${var.product}"
  }
}

resource "aws_route53_record" "jenkins2_eip_public" {
  zone_id = "${aws_route53_zone.public_facing.zone_id}"
  name    = "${var.environment}"
  type    = "A"
  ttl     = "3600"
  records = ["${aws_eip.jenkins2_eip.public_ip}"]
}
