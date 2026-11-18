terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "juice_shop" {
  name                 = "lab4-juice-shop"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = "devsecops-lab-4"
    Purpose = "software-supply-chain"
  }
}

output "ecr_repository_url" {
  description = "Private ECR repository URL for the lab image."
  value       = aws_ecr_repository.juice_shop.repository_url
}
