# Reliability Engineering CI Mission

## Important Links

* [Kick Off Document](https://docs.google.com/document/d/1s12pKTy34n3MKKaUhABhioFwi03Q-PdAsWi1tNck0DA/edit)

---
## Requirements

- Docker >= v18.03.0
- pre-commit 1.8.2
- Terraform >= v0.11.7

## Spinning up Jenkins2


```
cd docker
docker build -t="jenkins/jenkins-re" .
docker run --name myjenkins -ti -p 8000:80 -p 50000:50000 jenkins/jenkins-re:latest
```

## Accessing

Browse to [here](http://localhost:8000)


## Debugging

Access container as jenkins user:
```docker exec -u 1000 -it myjenkins /bin/bash```

Access container as root user:
```docker exec -it myjenkins /bin/bash```


## Using Terraform

1. Download and install terraform v0.11.7
2. Configure your ~/.aws/credentials file with your own details:

```
[re-build-systems]
aws_access_key_id = AABBCCDDEEFFG
aws_secret_access_key = abcdefghijklmnopqrstuvwxyz1234567890
```

3. Run terraform

```
cd terraform
terraform init
terraform plan
terraform apply
```

## Pre-commit checks

The main goal of this is to keep committed code tidy.

This is optional but highly recommended, especially if you would like to contribute.

```
brew install pre-commit
cd [your_git_working_copy]
pre-commit install --install-hooks
pre-commit autoupdate
```

## Provisioning a new AWS Environment

1. Install awscli:

```
brew install awscli python3
```

2. Create ~/.aws/credentials file:

```
[re-ci-mission]
aws_access_key_id = AABBCCDDEEFFG
aws_secret_access_key = abcdefghijklmnopqrstuvwxyz1234567890
```

Be careful not to use quotes in the above.

3. Create S3 bucket to host terraform state file:

```
cd [your_git_working_copy]
terraform/tools/create-s3-state-bucket -b re-build-systems -e test -p re-build-systems
```

_Where the `-e` parameter is the name of the environment._

4. Initialise terraform to use S3 Bucket, then plan and apply

The `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are those from the ~/.aws/credentials file. The

```
export AWS_ACCESS_KEY_ID="someaccesskey"
export AWS_SECRET_ACCESS_KEY="mylittlesecretkey"
export AWS_DEFAULT_REGION="eu-west-2"
terraform init -backend-config="region=eu-west-2" -backend-config="bucket=tfstate-re-build-systems-test" -backend-config="key=re-ci-mission.tfstate"
terraform plan -out my-plan
terraform apply my-plan
```

_Where the `-backend-config` parameter is appended with the name of the environment specified in the command in step 3 above._

## Sample app

A sample Java (Maven) app with a Jenkinsfile can be found at https://github.com/alphagov/re-build-systems-sample-java-app with
a Jenkins library hosted at https://github.com/alphagov/re-build-systems-sample-jenkins-library
