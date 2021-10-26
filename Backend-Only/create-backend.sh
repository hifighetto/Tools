#!/usr/bin/env bash

## This creates the basic terraform file backend.tf 
## More than likely there are better ways to do this, but this is how I have done it
## Suggestions welcome, hifighetto@gmail.com or github messages. 

## Get all the variables 
## You can put your bucket_name, Dynamodb table (bucket_table), and region here as hard coded
## this uses and AWS S3 backend for terraform with a dynamodb table 
project_name=$1
bucket_name=${2:-"ChangeToYourBucket"}
bucket_table=${3:-"ChangeToYourDynamoDBTable"}
bucket_region=${4:-"us-west-2"}

## create the 'backend.tf' with the basic inforamtion from above. 
cat > backend.tf <<-EOL
terraform {
  backend "s3" {
    encrypt        = "true"
    bucket         = "$bucket_name"
    key            = "terraform/states/$project_name.tfstate"
    region         = "$bucket_region"
    dynamodb_table = "$bucket_table"
  }
  required_providers {
    aws = {
      version = "3.63.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "$bucket_region"

}
EOL

echo "The backend.tf file was created with the following settings"
echo "Bucket Name: $bucket_name"
echo "Bucket key: terraform/states/$project_name.tfstate"
echo "DynamoDB Lock Table: $bucket_table"
echo "In the $bucket_region"