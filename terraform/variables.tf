variable "allowed_ips" {
  type = "list"
}

variable "aws_az" {
  type = "string"
}

variable "aws_profile" {
  type = "string"
}

variable "aws_region" {
  type = "string"
}

variable "dockerversion" {
  description = "Docker version to install"
  type        = "string"
}

variable "environment" {
  description = "Environment (test, staging, production, etc)"
  type        = "string"
}

variable "gitrepo" {
  type = "string"
}

variable "hostname_suffix" {
  type = "string"
}

variable "instance_type" {
  type        = "string"
  description = "This defines the default (aws) instance type."
  type        = "string"
  default     = "t2.small"
}

variable "product" {
  description = "The name of the product"
  type        = "string"
}

variable "server_name" {
  description = "Name of the jenkins2 server"
  type        = "string"
}

variable "server_storage_jenkins" {
  description = "Persistent Storage for the Jenkins Server"
  type        = "string"
}

variable "ubuntu_release" {
  description = "Which version of ubuntu to install"
  type        = "string"
}

variable "volume_size" {
  type        = "string"
  description = "This defines the default (aws) instance's root volume size."
  default     = "50"
}
