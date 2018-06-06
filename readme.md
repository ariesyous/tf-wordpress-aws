### AWS Terraform HA WordPress deployment

## Description:
This TF script will deploy a single region highly available WordPress site with RDS, EC2 and VPC. 

## Before running
Along with your API credentials, ensure you specify the AMI ID in your .tfvars file. A sample has been created to reference. Please use a cloud-ready Ubuntu Xenial image. For list of official AMI's see: https://cloud-images.ubuntu.com/locator/ec2/.

## Open issues
Need to find way to provision EC2 instances into multiple subnets (two web subnets, vs existing one) with 1 count variable, and also be able to provide the id's for the target group attachment. For now, all web servers are deployed into only one AZ. 

The code describing the extra subnet, NAT gateway, EIP along with the extra instance are commented out for now. 

### Networks to be provisioned:
- 1 VPC 
- 2 Database subnets 
- 1  Web subnets 
- 2  public subnets 

### Resources:
- 1 NLB
- 2 web servers (or more) (Ubuntu Xenial)
- 1 RDS instance (MySQL 5.7)

### Stratoscale Symphony Requirements:
- Load balancing enabled and initialized from the UI
- RDS Enabled with Mysql 5.7 engine initialized
- VPC mode enabled for tenant project

### Tested with: Terraform v0.11.7

