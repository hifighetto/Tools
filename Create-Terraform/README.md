## Create Terraform Files
### Basic Info

These scripts are for creating a basic terraform structure. The will create the file structure 
```
$ProjectName/
├── backend.tf
├── dev.tfvars
├── main.tf
└── variables.tf 
```

The script is set to use s3 as the backend for terraform and it creates the `variables.tf` based on that configuration for terraform v0.14.x 


### Usage 
The scripts are called from the command prompt with a shell file for mac and linux, and a batch file for windows.
The `project-name` is **REQUIRED** to be put after the command, everything else can be changed in the script as the default. 
Both the batch and bash scripts have the same requirements.
`create-terraform project-name s3-bucket-name dynamodb-table aws-region` 
<br>
There are default variables that can be changed in the scripts and you can hard code the 
s3-bucket-name = The s3 bucket for the terraform states 
dynamodb-table = The dynamodb table that has the digest and checksum for the s3 state files
aws-region = The aws region, us-east-1  
<br>
If you edit the variables in the relavant file then you do not have to enter them with each run 
`create-terraform project-name` examples are below. 


#### Linux/Mac 
The command is run after changing the variables listed below the output 
```
~/Repos/terraform/projects/examples/ ../../tools/create-terraform.sh basic
The following files were created in the basic directory

backend.tf
dev.tfvars
main.tf
variables.tf
```
Defaults:
```
bucket_name = ChangeToYourBucket
bucket_table = ChangeToYourDynamoDBTable
bucket_region = us-west-2
```
In the script you only need to change the part ChangeToYour...
Before 
```
bucket_name=${2:-"ChangeToYourBucket"}
```
After
```
bucket_name=${2:-"myniftys3bucket"}
```

#### Windows 
The command is run after changing the variables listed below the output 
```
C:\Users\hifighetto\Repos\terraform\projects\examples>..\..\..\Tools\Create-Terraform\create-terraform.bat basic
"Creating Terraform files for basic"

"Files Created in basic:"
backend.tf
dev.tfvars
main.tf
variables.tf
```
Defaults:
```
BucketName = ChangeToYourBucket
BucketTable = ChangeToYourDynamoDBTable
ProjectRegion = us-west-2
```
In the script you only need to change the part ChangeToYour...
Before 
```
if "%BucketName%"=="" set "BucketName=ChangeToYourBucket"
```
After
```
if "%BucketName%"=="" set "BucketName=myniftys3bucket"
```


##### Footnotes 
The windows script is ugly, and it leans on the echo command **A LOT** but it does work. <br>

The create-terraform.bat is done as a batch file instead of a powershell script because I am not a signed entity, and did not want to do the powershell script just yet. 
It could be better, and it could be cleaned up. One of the primary goals was to use as few files as possible, and both the windows and *nix scripts accomplish everything from within a single script. 

Changes or updates to things should be easy enough to use as they are raw terraform format. 
