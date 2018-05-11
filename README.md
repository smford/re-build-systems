# Reliability Engineering - Build Systems

This repository provides the infrastructure code for provisioning a containerised Jenkins instance on either a laptop or AWS.

## Contributing

Refer to our [Contributing guide](CONTRIBUTING.md).

## Provisioning Jenkins2 on your laptop for development

Skip this section if you are just trying to provision a Terraform plaftorm to use for your project.

This will provision a Docker container running Jenkins2 on your laptop.

You need `docker` >= `v18.03.0`

```
cd docker
docker build -t="jenkins/jenkins-re" .
docker run --name myjenkins -ti -p 8000:80 -p 50000:50000 jenkins/jenkins-re:latest
```

To access the instance browse to [here](http://localhost:8000)


For debugging, you can either:

* access container as jenkins user:
`docker exec -u 1000 -it myjenkins /bin/bash`

* access container as root user:
`docker exec -it myjenkins /bin/bash`


## Provisioning Jenkins2 on AWS

This will provision a containerized Jenkins instance on AWS.

1. Have the dependencies installed:

    * Terraform v0.11.7

    * `brew install awscli python3`

1. Configure your ~/.aws/credentials file with your own details:

    ```
    [re-build-systems]
    aws_access_key_id = AABBCCDDEEFFG
    aws_secret_access_key = abcdefghijklmnopqrstuvwxyz1234567890
    ```

    Be careful not to use quotes in the above.

1. Decide on an environment name, which will be referred as `[environment-name]` from now on.
That is usually something like `test`, `staging`, `production` or your name if you are doing development or testing (e.g. `daniele`).

1. Have a "config directory" for your sensitive data with this structure (e.g. a checked-out repository):

    ```
    |-- re-build-system            <-- this repository
    |-- configuration-directory
    |   |-- terraform
    |       |-- keys               <-- your public keys are in this directory
    |       |-- terraform.tfvars
    
    ```

1. Create S3 bucket to host terraform state file:

    ```
    cd [your_git_working_copy]
    terraform/tools/create-s3-state-bucket -b re-build-systems -e [environment-name] -p re-build-systems
    ```

1. Export secrets

    In order to initialise with Terraform the S3 bucket we have created, we need to export some secrets from the `~/.aws/credentials` file.

    ```
    export AWS_ACCESS_KEY_ID="someaccesskey"
    export AWS_SECRET_ACCESS_KEY="mylittlesecretkey"
    export AWS_DEFAULT_REGION="eu-west-2"
    ```

1. Run Terraform

    ```
    cd terraform
    terraform init -backend-config="region=eu-west-2" -backend-config="bucket=tfstate-re-build-systems-[environment-name]" -backend-config="key=re-build-systems.tfstate"
    terraform apply -var-file=../../re-build-systems-config/terraform/terraform.tfvars  -var environment=[environment-name]
    ```

1. Use the new Jenkins instance

    The previous `terraform apply` output some values. The most interesting is `jenkins2_eip`.

    * Visit the Jenkins installation at `http://[jenkins2_eip]`
    
    * SSH into the instance with `ssh -i [path-to-your-private-ssh-key] ubuntu@[jenkins2_eip]`
        * Contact the `RE Build Tools` team to get the private key.
        * To switch to the root user, run `sudo su -`
    


## Licence

[MIT License](LICENCE)