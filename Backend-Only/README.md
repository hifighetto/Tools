## Backend-Only 
This creates the `backend.tf` file for terraform. This can be useful since i stopped including my default backend files. <br>

### Useage 
This is used for keeping terraform in a shared state so that more than one user can create/modify/deploy terraform projects at one time. It requires a DynamoDB lock table, and and s3 bucket. The full requirements can be found [here](https://www.terraform.io/docs/language/settings/backends/s3.html)<br>

##### S3 Bucket 
Create an S3 bucket to be able to upload the shared state files. This needs to follow the s3 bucket rules of a unique name for the bucket.

##### DynamoDB Table 
The dynamoDb table needs to exist as well. it needs to have the primary key named `LockID` with the value of `string` 
The `LockID` is case sensitive. 


### Updates 
Please update the variables in the bash or batch file to be your S3 Bucket name, DynamoDB table, and region. 
