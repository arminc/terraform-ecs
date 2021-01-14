provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "ecs" {
  source = "./modules/ecs"

  environment          = var.environment
  cluster              = var.environment
  cloudwatch_prefix    = "${var.environment}"           #See ecs_instances module when to set this and when not!
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  max_size             = var.max_size
  min_size             = var.min_size
  desired_capacity     = var.desired_capacity
  key_name             = aws_key_pair.ecs.key_name
  instance_type        = var.instance_type
  ecs_aws_ami          = var.aws_ecs_ami
}

resource "aws_key_pair" "ecs" {
  key_name   = "ecs-key-${var.environment}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtMljjj0Ccxux5Mssqraa/iHHxheW+m0Rh17fbd8t365y9EwBn00DN/0PjdU2CK6bjxwy8BNGXWoUXiSDDtGqRupH6e9J012yE5kxhpXnnkIcLGjkAiflDBVV4sXS4b3a2LSXL5Dyb93N2GdnJ03FJM4qDJ8lfDQxb38eYHytZkmxW14xLoyW5Hbyr3SXhdHC2/ecdp5nLNRwRWiW6g9OA6jTQ3LgeOZoM6dK4ltJUQOakKjiHsE+jvmO0hJYQN7+5gYOw0HHsM+zmATvSipAWzoWBWcmBxAbcdW0R0KvCwjylCyRVbRMRbSZ/c4idZbFLZXRb7ZJkqNJuy99+ld41 ecs@aws.fake"
}

variable "environment" {
  description = "A name to describe the environment we're creating."
}
variable "aws_profile" {
  description = "The AWS-CLI profile for the account to create resources in."
}
variable "aws_region" {
  description = "The AWS region to create resources in."
}
variable "aws_ecs_ami" {
  description = "The AMI to seed ECS instances with."
}
variable "vpc_cidr" {
  description = "The IP range to attribute to the virtual network."
}
variable "public_subnet_cidrs" {
  description = "The IP ranges to use for the public subnets in your VPC."
  type = list
}
variable "private_subnet_cidrs" {
  description = "The IP ranges to use for the private subnets in your VPC."
  type = list
}
variable "availability_zones" {
  description = "The AWS availability zones to create subnets in."
  type = list
}
variable "max_size" {
  description = "Maximum number of instances in the ECS cluster."
}
variable "min_size" {
  description = "Minimum number of instances in the ECS cluster."
}
variable "desired_capacity" {
  description = "Ideal number of instances in the ECS cluster."
}
variable "instance_type" {
  description = "Size of instances in the ECS cluster."
}

output "default_alb_target_group" {
  value = module.ecs.default_alb_target_group
}
