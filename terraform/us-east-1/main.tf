terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket = "randomwithfriends-tfstate"
    key    = "us-east-1"
    region = "ap-southeast-2"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

module "random-with-friends" {
  source = "../modules/random-with-friends"

}
