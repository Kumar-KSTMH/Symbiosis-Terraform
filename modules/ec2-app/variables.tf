variable "project_name" {}
variable "environment" {}
variable "ami_id" {}
variable "instance_type" {}
variable "app_subnet_1a_id" {}
variable "app_subnet_1b_id" {}
variable "app_sg" {}
variable "key_name" {}
variable "iam_instance_profile_name" {}
variable "ebs_kms_key_arn" {
  description = "KMS key ARN for EC2 EBS volumes"
  type        = string
}
