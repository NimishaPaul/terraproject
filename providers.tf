terraform {
  required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "4.5.0"
      }
  }
 backend "s3" {
    bucket         = "project-nimi-bucket"
    key            = "key/terraform.tfstate"
    region         = "us-east-2"
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}
