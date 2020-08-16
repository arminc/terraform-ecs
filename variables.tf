variable "aws_region" {
  default = "eu-west-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  description = "VPC cidr block. Example: 10.0.0.0/16"
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

variable "load_balancers" {
  type        = list
  default     = []
  description = "The load balancers to couple to the instances"
}

variable "desired_capacity" {
  default = 1
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ecs_aws_ami" {
  description = "The AWS ami id to use for ECS. Should be an ECS-optimized image."
  default = "ami-95f8d2f3"
}

variable "private_subnet_cidrs" {
  type = list
  default = ["10.0.50.0/24", "10.0.51.0/24"]
  description = "List of private cidrs, for every avalibility zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
}

variable "public_subnet_cidrs" {
  type = list
  default = ["10.0.0.0/24", "10.0.1.0/24"]
  description = "List of public cidrs, for every avalibility zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
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

variable "ecs_config" {
  default     = "echo '' > /etc/ecs/ecs.config"
  description = "Specify ecs agent configuration or get it from S3. Example: aws s3 cp s3://some-bucket/ecs.config /etc/ecs/ecs.config"
}

variable "custom_userdata" {
  default     = ""
  description = "Inject extra command in the instance template to be run on boot"
}

variable "instance_group" {
  default     = "default"
  description = "The name of the instances that you consider as a group"
}

variable "ecs_logging" {
  default     = "[\"json-file\",\"awslogs\"]"
  description = "Adding logging option to ECS that the Docker containers can use. It is possible to add fluentd as well"
}
