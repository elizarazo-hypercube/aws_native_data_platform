terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.13.0"
    }
  }
  backend "s3" {
    bucket = "hypercube-dataplatform-tfstate"
    key    = "dataplatform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      Environment = "development"
      CreatedBy   = "terraform"
      Repository  = "https://github.com/wearehypercube/hypercube-data_platform-zenobe"
    }
  }
}

module "datazone" {
  source       = "../../modules/datazone"
  environment  = "development"
  company_name = "hypercube"
  git_repo     = "https://github.com/wearehypercube/hypercube-data_platform-zenobe"
}

module catalog {
  source      = "../../modules/catalog"
}