module "jenkins2_server" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "1.5.0"
  name                        = "${var.server_name}.${var.environment}.${var.hostname_suffix}"
  ami                         = "${data.aws_ami.source.id}"
  instance_type               = "${var.server_instance_type}"
  associate_public_ip_address = true
  user_data                   = "${data.template_file.docker-jenkins2-server-template.rendered}"
  key_name                    = "jenkins2_key_${var.product}-${var.environment}"
  monitoring                  = true
  vpc_security_group_ids      = ["${module.jenkins2_security_group.this_security_group_id}", "${module.jenkins2_security_group_cloudflare.this_security_group_id}"]
  subnet_id                   = "${element(module.jenkins2_vpc.public_subnets,0)}"

  root_block_device = [{
    volume_size           = "${var.server_root_volume_size}"
    delete_on_termination = "true"
  }]

  tags {
    Environment = "${var.environment}"
    ManagedBy   = "terraform"
    Name        = "jenkins2_ec2_${var.product}_${var.environment}"
    Product     = "${var.product}"
  }
}

data "aws_ami" "source" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-${var.ubuntu_release}-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "docker-jenkins2-server-template" {
  template = "${file("cloud-init/master-${var.ubuntu_release}.yaml")}"

  vars {
    dockerversion = "${var.dockerversion}"
    fqdn          = "${var.server_name}.${var.hostname_suffix}"
    gitrepo       = "${var.gitrepo}"
    hostname      = "${var.server_name}.${var.hostname_suffix}"
    region        = "${var.aws_region}"
  }
}

resource "aws_ebs_volume" "jenkins2_server_storage" {
  availability_zone = "${var.aws_az}"
  size              = "${var.server_persistent_storage_size}"
  type              = "gp2"

  lifecycle {
    ignore_changes = ["size", "type"]
  }

  tags {
    Environment = "${var.environment}"
    ManagedBy   = "terraform"
    Name        = "jenkins2_ebs_${var.product}_${var.environment}"
    Product     = "${var.product}"
  }
}

resource "aws_volume_attachment" "jenkins2_server_storage_attachment" {
  device_name = "/dev/xvdf"
  volume_id   = "${aws_ebs_volume.jenkins2_server_storage.id}"
  instance_id = "${element(module.jenkins2_server.id,0)}"
}

#resource "aws_route53_record" "jenkins2_private" {
#  zone_id = "${aws_route53_zone.private_facing.zone_id}"
#  name    = "jenkins2-server"
#  type    = "A"
#  ttl     = "3600"
#  records = ["${aws_eip.jenkins2_eip.public_ip}"]
#}

resource "aws_route53_record" "jenkins2_server_private" {
  zone_id = "${aws_route53_zone.private_facing.zone_id}"
  name    = "${var.server_name}"
  type    = "A"
  ttl     = "3600"
  records = ["${module.jenkins2_server.private_ip}"]
}
