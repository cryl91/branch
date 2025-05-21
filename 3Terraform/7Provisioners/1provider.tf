terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.92.0"
    }
  }

}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

#To keep state file in remote s3 bucket and lock with dynamo db
 
  
