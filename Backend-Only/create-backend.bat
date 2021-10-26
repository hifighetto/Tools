@echo off

:: This is just run by going `create-backend.bat` 
:: This will create the backend.tf in the local directory 
:: There are better ways to do this, but here we are
:: Batch is pretty ugly. 
:: This is a really ugly way to create a couple of template files
:: It leans HEAVILY on 'echo' to drop the data into the files. 
:: It aint pretty, but it works 
setlocal enabledelayedexpansion

:: This requires the project name in line 'create-backend.bat projectname' 
:: There are better ways to do this, but 
set ProjectName=%1
if "%1"=="" GOTO BasicMessage

:: the rest of the variables work fine with the extra space 
:: create-backend.tf project bucket dynamodb-table project-region 
:: create-backend.tf vpv-main s3-hifi-terraform-states dynamo-hifi-locktable us-west-2 
set BucketName=%2
if "%BucketName%"=="" set "BucketName=ChangeToYourBucket"

set BucketTable=%3
if "%BucketTable%"=="" set "BucketTable=ChangeToYourDynamoDBTable"

set ProjectRegion=%4
if "%ProjectRegion%"=="" set "ProjectRegion=us-west-2"

set PathName=%ProjectName%

echo "Creating Terraform files for %ProjectName%"

:: Creates the backend.tf 
echo terraform { > backend.tf
echo   backend "s3" { >> backend.tf
echo     bucket         = "01-hifighetto-terraform" >> backend.tf
echo     key            = "terraform/states/%ProjectName%.tfstate" >> backend.tf
echo     region         = "%ProjectRegion%" >> backend.tf
echo     dynamodb_table = "%BucketTable%" >> backend.tf
echo   } >> backend.tf
echo   required_providers { >> backend.tf
echo     aws = { >> backend.tf
echo       version = "3.63.0" >> backend.tf
echo       source  = "hashicorp/aws" >> backend.tf
echo     } >> backend.tf
echo   } >> backend.tf
echo } >> backend.tf
echo( >> backend.tf
echo provider "aws" { >> backend.tf
echo   region = "%ProjectRegion%" >> backend.tf
echo } >> backend.tf

GOTO End

:BasicMessage 
echo Requires a project name
echo Run: "create-backend.bat project-name"

:End