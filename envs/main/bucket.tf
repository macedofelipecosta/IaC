terraform {
  backend "s3" {
    bucket  = "217821-terraform-state"
    key     = "main/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
