Steps done:

1. Terraform S3 backend created using the `infrastructure/oneofscripts/tfstate_bucket.sh`
2. Deployed datazone v2 (which is sage maker unified studio)
3. Created manage_access_role, provisioning_role and query_execution_role
4. Created project profile using UI (there doesn't seem to be an alternative) and added the terraform created roles and S3 buckets, (will add VPC ones created by CloudTeam)
5. Created connection to Github
6. Go to Project profiles and edit the SQL analytics profile so that we can use Github as the repo
6. Created Analytics project in SageMakerUnifiedStudio


Steps remaining:

*


Sage Maker Unified Studio

Adding a data source to Sagemaker lakehouse requires giving permissions to sagemaker to query the resource BEFORE adding the resource

There is one catalog per account region,
Can create databases per environment 
Need to setup Administrative roles in lake formation (can this be done with terraform)
Once becoming a lakeformation admin can grant permissions using ABAC
LF Tags have to be created on the Permissions/LF-Tags and permissions in Lake Formation,
these tags can then be used on table or databases, e.g if we set up a environment=dev LF-Tag we can associate this with the development tables so that users which have this tag associated with them can see the data

On sagemaker unified studio go to project -> data -> +Add -> copy project information
go to lake formation -> data permissions -> grant -> use role 
go to sagemaker unified studio -> project catalog -> data sources (at this point the database becomes selectable) add and now you can see the data in sagemakesunifiedstudio


On sagemaker unified studio go to project -> data -> +Add -> copy project information
go to IAM and add the tags that are relevant for the domain role
then anyone with access to the domain should be able to query the same data with the same restrictions as they would be using this particular role

can we get the role from terraform? or do we add it by hand?