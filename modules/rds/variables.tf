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
