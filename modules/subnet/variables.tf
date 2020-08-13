variable "name" {
  description = "Name of the subnet, actual name will be, for example: name_eu-west-1a"
}

variable "environment" {
  description = "The name of the environment"
}

variable "cidrs" {
  type        = list
  description = "List of cidrs, for every avalibility zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
}

variable "availability_zones" {
  type        = list
  description = "List of avalibility zones you want. Example: eu-west-1a and eu-west-1b"
}

variable "vpc_id" {
  description = "VPC id to place to subnet into"
}
