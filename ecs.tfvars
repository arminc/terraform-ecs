# The AWS-CLI profile for the account to create resources in.
aws_profile = "default"

# The AWS region to create resources in.
aws_region = "eu-west-1"

# The AMI to seed ECS instances with.
# Leave empty to use the latest Linux 2 ECS-optimized AMI by Amazon.
aws_ecs_ami = ""

vpc_cidr = "10.0.0.0/16"

environment = "acc"

public_subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24"]

private_subnet_cidrs = ["10.0.50.0/24", "10.0.51.0/24"]

availability_zones = ["eu-west-1a", "eu-west-1b"]

max_size = 1

min_size = 1

desired_capacity = 1

instance_type = "t2.micro"
