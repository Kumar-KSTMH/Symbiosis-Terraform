variable "project_name" {}
variable "web_subnet_1a_id" {}
variable "web_subnet_1b_id" {}
variable "web_alb_tg_arn" {}
variable "web_launch_template" {
  description = "Web tier launch template object"
  type = object({
    id              = string
    latest_version  = string
  })
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
