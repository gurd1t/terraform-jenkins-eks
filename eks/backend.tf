terraform {
  backend "s3" {
    bucket = "gurdit-cicd-terraform-eks"
    key    = "eks/terraform.tfstate"
    region = var.region
  }
}
