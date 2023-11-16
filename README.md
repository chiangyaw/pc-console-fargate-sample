# Prisma Cloud Compute Edition - Console on ECS Fargate

This is a sample Terraform script to deploy Prisma Cloud Compute Edition Console on ECS Fargate. 

## Objective
The main objective of this sample Terraform script is to allow customers or partners to deploy Prisma Cloud Compute Edition Console on ECS Fargate, and also allow them to try out the deployment or configuration in their testing environment. The scripts are not meant for production deployment. Therefore, use at your own risk.

## Requirement
In order for you to test this out, you will need the following:
- An AWS Account 
- Terraform installed on your machine
- Prisma Cloud Compute Edition License
- Basic understanding on deploying Fargate and AWS resources

### Instruction
The sample Terraform script will covers the a full deployment from VPC, Subnets, Security Group, NLB, ECS Cluster, ECS Task, ECS Services, etc. 

14th Nov 2023 - As of today, I can't think of a way to fully automate the deployment at a single go yet. One way to create a template and allow aws_ecs_task_definition to consume the newly generated file. This is still Work in Progress.

1. To start off, you will first need to generate a mock up task definition file. To generate a task definition file for console to be deployed in Fargate, refer to the weblink [here](https://docs.prismacloud.io/en/compute-edition/30/admin-guide/install/deploy-console/console-on-fargate). The initial package can be downloaded via the weblink from Release Note, which you can obtain from Palo Alto Networks CSP portal. You will also need a registry token, which should be provided to you to download the console image upon new purchase of Prisma Cloud Compute Edition.

2. Once you have the initial package, you can generate a mock up task definition file via twistcli as below:
```
./linux/twistcli console export fargate \
--registry-token abc-123  \
--cluster-ip my-fargate-console-dns-address.elb.us-east-1.amazonaws.com \
--memory-limit 8192 \
--cpu-limit 2048 \
--efs-volume fs-12345678
```
3. Copy only the container definition portion (you can look into ```sample-twistlock-console.json``` as an example) and paste into the directory, so that you can run it together as part of the Terraform scripts. Make sure you modify the name and the path as ```var.container_def_path```. 

**Note: You probably will ask the question why do we need to generate a mock up fargate tasks definition file. The main reason is because I'm using the same set of Terraform scripts to generate other components such as NLB, which is required as part of the task definition file, and these parameters are not available at this stage yet. Therefore would require the mock up template.**

3. To start off, first prepare ```variable.tf``` file or create ```terraform.tfvars``` file to define the variables required. The template includes some default value of the variables for your reference.

4. Ensure you have your Terraform & AWS account ready with the required permission access via programmatic access. If you have not done this before, there are many ways to do it. You can refer to this 3rd party reference [page](https://medium.com/@CloudTopG/discover-the-3-steps-to-creating-an-iam-user-with-access-secret-access-keys-for-terraform-scripts-28110e280460) for more details.

5. Once the AWS accounts, credentials have been setup, execute ```terraform init``` and ```terraform apply``` on your terminal.

6. Once everything is deployed successfully, you should see an output of ```nlb_dns_name``` & ```efs_id```, which can be used to re-generate the task definition (similar to what you do in step 3).

7. Once you have done this, just re-run ```terraform apply```.

8. Once done, you should be able to access the console via ```https://<nlb_dns_name>:8083```. Do allow 5-10 minutes for the ECS Fargate to be provisioned.

## Clean Up
To remove the testing environment, just do a ```terraform destroy```.
