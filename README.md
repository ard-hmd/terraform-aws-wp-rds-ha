# AWS Infrastructure Deployment with Terraform

This Terraform code has been designed to deploy a comprehensive AWS infrastructure for a web application. Below are the main components of this setup:

## Key Components

- **VPC (Virtual Private Cloud)**: A virtual network dedicated to your AWS environment.
- **Subnets**: Creation of public and private subnets across different availability zones.
- **Internet Gateway**: Allows communication between instances in the VPC and the Internet.
- **NAT Gateway**: Enables instances in private subnets to initiate outbound connections to the Internet.
- **Route Tables**: Routing tables for both public and private subnets.
- **EC2 Instances**: EC2 instances for the web application and a "bastion" instance for secure access.
- **Load Balancer**: A load balancer to distribute incoming traffic to EC2 instances.
- **Security Groups**: Security groups to define access rules for EC2 instances, the load balancer, and the RDS database.
- **RDS (Relational Database Service)**: A MySQL database instance and a replica for storing application data.
- **Autoscaling Group**: An autoscaling group to manage the number of EC2 instances based on load.

## Installation Instructions

1. **Terraform Initialization**
```shell
terraform init
```

3. **Creating the secrets.tfvars File**
```shell
db_username = "your_username"
db_password = "your_password"
```
> **Note:**  Create this file to store sensitive values like the database username and password. Refer to the sample content in the documentation.

4. **Planning the Deployment**
```shell
terraform plan -var-file=secrets.tfvars

```

5. **Applying the Plan**
```shell
terraform apply -var-file=secrets.tfvars

```

## Destroying the Infrastructure (if needed)
```shell
terraform destroy -var-file=secrets.tfvars
```

If you need to remove the deployed infrastructure, execute the provided command.

Please be aware of the consequences of this action as it will delete all created resources.

> **Note:** Ensure sensitive information-containing files (like `secrets.tfvars`) are kept secure and not shared publicly.

For more details on using Terraform and deploying infrastructures on AWS, refer to the official documentation.
