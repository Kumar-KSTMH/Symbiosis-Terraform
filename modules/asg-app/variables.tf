variable "project_name" {}
variable "app_subnet_1a_id" {}
variable "app_subnet_1b_id" {}
variable "app_alb_tg_arn" {}
variable "app_launch_template_id" {
  type = string
}

variable "app_lt_version" {
  type = string
}


variable "instance_type" {
  default = "t3.medium"
}
variable "max_size" {
  default = 6
}
variable "min_size" {
  default = 2
}
variable "desired_capacity" {
  default = 2
}
variable "asg_health_check_type" {
  default = "ELB"
}
