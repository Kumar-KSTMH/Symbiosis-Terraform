terraform {
  backend "s3" {
    bucket         = "symbiosis-terraform-state"
    key            = "dev/symbiosis-terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "symbiosis-terraform-locks"
  }
}
