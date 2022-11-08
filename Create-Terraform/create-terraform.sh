#!/usr/bin/env bash

## This creates the basic terraform files that I use. 
## More than likely there are better ways to do this, but this is how I have done it
## Suggestions welcome, hifighetto@gmail.com or github messages. 

## Get all the variables 
## You can put your bucket_name, Dynamodb table (bucket_table), and region here as hard coded
## this uses and AWS S3 backend for terraform with a dynamodb table 
project_name=$1
bucket_name=${2:-"ChangeToYourBucket"}
bucket_table=${3:-"ChangeToYourDynamoDBTable"}
project_region=${4:-"us-west-2"}



## Programs Used 
use_mkdir=$(which mkdir)
use_touch=$(which touch)

# Get the terraform version 
get_terraform_version=$(terraform -version | head -1 | cut -c 11-20)

## If no project name is given print usage message and exit 
if [ -z "$project_name" ]
 then 
    echo ""
    echo "Requires at least a bucket name" 
    echo ""
    echo "Basic Usage 'create-terraform.sh project-name'"
    echo ""
else

## Make the directory for the project name, then throw an empty 'main.tf' into it 
"$use_mkdir" "$project_name"
"$use_touch" "$project_name"/main.tf

## create the 'backend.tf' with the basic inforamtion from above. 
cat > "$project_name"/backend.tf <<-EOL
terraform {
  backend "s3" {
    encrypt        = "true"
    bucket         = "$bucket_name"
    key            = "terraform/states/$project_name.tfstate"
    region         = "$project_region"
    dynamodb_table = "$bucket_table"
  }
  required_providers {
    aws = {
      version = "4.25.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "$project_region"

}
EOL


## This creates a generic 'dev.tfvars' file with the basic values filled in
## Feel free to change this to your default values or filename 

cat > "$project_name"/dev.tfvars <<-EOL
env    = "dev"
region = "$project_region"

standard_tags = {
  "Environment" = "dev"
  "Project"     = "$project_name"
  "Terraform"   = "$get_terraform_version"
  "AWS Version" = "3.22.0"
}
EOL

cat > "$project_name"/variables.tf <<-EOL
variable "env" {
  description = "Environment variable"
}

variable "region" {
  description = "The region you are working in"
}

variable "standard_tags" {
  description = "Tags you want to use"
}
EOL

echo "The following files were created in the $project_name directory"
# Shellcheck error, after all the good examples above. 
# shellcheck disable=SC2012
ls -l "$project_name" | awk -F ' ' '{print $9}'
fi

