variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
}

variable "public_key_path" {
  type        = string
  description = "Path to the public key file"
}