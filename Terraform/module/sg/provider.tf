terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.92.0"
    }
  }

#   #Before locking the file, create a s3 bucket and dynamodb table in aws
#   backend "s3" {
#     bucket = "terraform-bucket-cyril"
#     key    = "foreach-demo"
#     region = "us-east-1"
#     dynamodb_table = "cyril-lock"
# }

}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

#To keep state file in remote s3 bucket and lock with dynamo db
 
  
