output "image_id" {
  value = "${data.aws_ami.source.id}"
}

output "jenkins2_eip" {
  value = "${aws_eip.jenkins2_eip.public_ip}"
}

output "jenkins2_security_group_id" {
  description = "jenkins2 default security group id"
  value       = "${module.jenkins2_security_group.this_security_group_id}"
}

output "jenkins2_vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.jenkins2_vpc.vpc_id}"
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${module.jenkins2_vpc.public_subnets}"]
}
