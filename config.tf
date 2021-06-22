terraform {
  required_version = "~> 1.0.0"
  required_providers {
    genesyscloud = {
      source  = "mypurecloud/genesyscloud"
      version = "~> 0.9.0"
    }
  }
  backend "s3" {
    key            = "johnson-widgets.tfstate"
    encrypt        = true
  }
}