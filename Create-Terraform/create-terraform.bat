@echo off
:: Batch is pretty ugly. 
:: This is a really ugly way to create a couple of template files
:: It leans HEAVILY on 'echo' to drop the data into the files. 
:: It aint pretty, but it works 
setlocal enabledelayedexpansion

:: This requires the project name in line 'create-terraform.bat projectname' 
:: There are better ways to do this, but 
set ProjectName=%1
if "%1"=="" GOTO BasicMessage

:: the rest of the variables work fine with the extra space 
set BucketName=%2
if "%BucketName%"=="" set "BucketName=ChangeToYourBucket"

set BucketTable=%3
if "%BucketTable%"=="" set "BucketTable=ChangeToYourDynamoDBTable"

set ProjectRegion=%4
if "%ProjectRegion%"=="" set "ProjectRegion=us-west-2"

set PathName=%ProjectName%

echo "Creating Terraform files for %ProjectName%"
mkdir %PathName%

:: Get the variable for the terraform version 
set CHECKPOINT_DISABLE=true
for /f "tokens=2 USEBACKQ delims= " %%f in (`terraform version`) do (
    set tfver=%%f
)

:: Creates the backend.tf 
echo terraform { > %PathName%\backend.tf
echo   backend "s3" { >> %PathName%\backend.tf
echo     encrypt        = "true" >> %PathName%\backend.tf
echo     bucket         = "%BucketTable%" >> %PathName%\backend.tf
echo     key            = "terraform/states/%ProjectName%.tfstate" >> %PathName%\backend.tf
echo     region         = "%ProjectRegion%" >> %PathName%\backend.tf
echo     dynamodb_table = "%BucketTable%" >> %PathName%\backend.tf
echo   } >> %PathName%\backend.tf
echo   required_providers { >> %PathName%\backend.tf
echo     aws = { >> %PathName%\backend.tf
echo       version = "4.25.0" >> %PathName%\backend.tf
echo       source  = "hashicorp/aws" >> %PathName%\backend.tf
echo     } >> %PathName%\backend.tf
echo   } >> %PathName%\backend.tf
echo } >> %PathName%\backend.tf
echo( >> %PathName%\backend.tf
echo provider "aws" { >> %PathName%\backend.tf
echo   region = "%ProjectRegion%" >> %PathName%\backend.tf
echo } >> %PathName%\backend.tf


:: Create  the main.tf file 
echo. 2> %ProjectName%\main.tf

:: This part is for the variables defaults. 
:: These are common variables that are used across all the projects
echo variable "env" { > %ProjectName%\variables.tf 
echo   description = "Environment variable" >> %ProjectName%\variables.tf 
echo } >> %ProjectName%\variables.tf 
echo( >> %ProjectName%\variables.tf 
echo variable "region" { >> %ProjectName%\variables.tf 
echo   description = "The region you are working in" >> %ProjectName%\variables.tf 
echo } >> %ProjectName%\variables.tf 
echo( >> %ProjectName%\variables.tf 
echo variable "standard_tags" { >> %ProjectName%\variables.tf 
echo   description = "Tags you want to use" >> %ProjectName%\variables.tf 
echo } >> %ProjectName%\variables.tf 

:: Create the dev.tfvars file. Still messy 
echo env    = "dev" > %PathName%\dev.tfvars
echo region = "%ProjectRegion%" >> %PathName%\dev.tfvars
echo( >> %PathName%\dev.tfvars
echo standard_tags = { >> %PathName%\dev.tfvars
echo   "Environment" = "dev" >> %PathName%\dev.tfvars
echo   "Project"     = "%ProjectName%" >> %PathName%\dev.tfvars
echo   "Terraform"   = "%tfver%" >> %PathName%\dev.tfvars
echo   "AWS Version" = "3.22.0" >> %PathName%\dev.tfvars
echo } >> %PathName%\dev.tfvars


echo "Files Created in %ProjectName%:"
dir /b %ProjectName%

GOTO End

:BasicMessage 
echo Requires a project name
echo Run: "create-terraform.bat project-name"

:End
