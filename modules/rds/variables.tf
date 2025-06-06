variable "vpc_id" {}
variable "project_name" {}
variable "environment" {}
variable "db_sg" {}
variable "db_subnets" {}
variable "db_username" {}
variable "db_password" {}
variable "db_name" {
  default = "symbiosismysqldb"
}
variable "rds_kms_key_arn" {
  description = "KMS key ARN for RDS"
  type        = string
}

