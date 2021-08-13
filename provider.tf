terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Provider for aws

provider "aws" {
  region = var.ntier_vpc_region
}
