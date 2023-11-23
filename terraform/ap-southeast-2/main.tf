terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket = "randomwithfriends-tfstate"
    key    = "ap-southeast-2"
    region = "ap-southeast-2"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-2"
}

module "random-with-friends" {
  source = "../modules/random-with-friends"

}
