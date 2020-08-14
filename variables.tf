variable "aws_region" {
  default = "eu-west-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "environment" {
  default = "eng"
}

variable "max_size" {
  default = 1
}

variable "min_size" {
  default = 1
}

variable "desired_capacity" {
  default = 1
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ecs_aws_ami" {
  default = "ami-95f8d2f3"
}

variable "private_subnet_cidrs" {
  type = list
  default = ["10.0.50.0/24", "10.0.51.0/24"]
}

variable "public_subnet_cidrs" {
  type = list
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "availability_zones" {
  type = list
  default = ["eu-west-1a", "eu-west-1b"]
}

variable "ecs_public_key" {
  description = "Contents of an SSH RSA public key to access the ECS host."
}

variable "cloudwatch_prefix" {
  default     = ""
  description = "If you want to avoid cloudwatch collision or you don't want to merge all logs to one log group specify a prefix"
}

variable "cluster_name" {
  description = "Name of the ECS cluster to create"
}
