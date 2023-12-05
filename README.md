# Random with friends

A web application to choose a random choice in realtime with other people.

# Get started

## Prerequisites
* aws cli
* terraform

## AWS
1. Install AWS CLI
1. setup SSO
```
aws sso login
SSO session name (Recommended): admin
SSO start URL [None]: https://d-97675aafd8.awsapps.com/start
SSO region [None]: ap-southeast-2
SSO registration scopes [sso:account:access]:
```

## Terraform
The AWS resources are defined in a shared modules `./terraform/modules/`. This module is included in the 'root' modules where each 'root' module is for a specific environment and region combination.

First, init terraform to download the plugins.
```
cd terraform
terraform init
```

To deploy to `ap-southeast-2` region, cd to `./terraform/ap-southeast-2`. Validate terraform first by running
```
terraform plan
```

then to deploy run
```
terraform apply
```

Repeat for each environment/region.

## AWS Lambda
The backend is is a serverless application implemented using AWS API Gateway + lambdas.