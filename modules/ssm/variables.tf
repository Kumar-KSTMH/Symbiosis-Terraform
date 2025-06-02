variable "db_host" {
  description = "Hostname or endpoint of the RDS database"
  type        = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
