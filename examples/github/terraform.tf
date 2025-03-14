terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
    corefunc = {
      source  = "northwood-labs/corefunc"
      version = "~> 1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.0"
    }
  }

  required_version = ">= 1.3"
}
