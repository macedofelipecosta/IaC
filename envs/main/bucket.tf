terraform {
  backend "s3" {
    bucket  = "states-terraform-217821"
    key     = "main/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
