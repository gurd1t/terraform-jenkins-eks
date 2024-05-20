terraform {
  backend "s3" {
    bucket = "gurdit-cicd-terraform-eks"
    key    = "jenkins/terraform.tfstate"
    region = var.region
  }
}
