variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
}

variable "azs" {
  type = list(string)
}

variable "public_key_path" {
  type        = string
  description = "Path to the public key file"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "web_subnet_1a_cidr" {
  description = "CIDR block for the web subnet in az1"
  type        = string
}

variable "web_subnet_1b_cidr" {
  description = "CIDR block for the web subnet in az2"
  type        = string
}

variable "app_subnet_1a_cidr" {
  description = "CIDR block for the app subnet in az1"
  type        = string
}

variable "app_subnet_1b_cidr" {
  description = "CIDR block for the app subnet in az2"
  type        = string
}

variable "db_subnets_cidr" {
  description = "CIDR block for the db subnets"
  type        = list(string)
}

variable "instance_type" {
  description = "Instance type for server"
  type        = string
}

variable "key_name" {
  description = "Private key-pair"
  type        = string
}

variable "db_username" {
  description = "RDS database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}

# variable "certificate_domain_name" {}
# variable "additional_domain_name" {}