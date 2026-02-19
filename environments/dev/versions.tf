terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket = "def-terraform-state-jj"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    #    dynamodb_table = "terraform-locks"
    use_lockfile = true
    encrypt      = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.30"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

