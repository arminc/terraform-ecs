terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.aws_region
}

module "ecs" {
  source = "./modules/ecs"

  environment          = var.environment
  cluster              = var.environment
  cloudwatch_prefix    = var.environment           #See ecs_instances module when to set this and when not!
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  max_size             = var.max_size
  min_size             = var.min_size
  desired_capacity     = var.desired_capacity
  key_name             = aws_key_pair.ecs.key_name
  instance_type        = var.instance_type
  ecs_aws_ami          = var.ecs_aws_ami
}

resource "aws_key_pair" "ecs" {
  key_name   = "ecs-key-${var.environment}"
  # DO NOT USE THIS DEFAULT VALUE, IT WILL LEAVE YOUR ENVIRONMENT ACCESSIBLE TO ANYONE
  # Replace this with your own public key
  public_key = var.ecs_public_key
}
