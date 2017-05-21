variable "environment" {
  description = "The name of the environment"
}

variable "cluster" {
  default     = "default"
  description = "The name of the ECS cluster"
}

variable "prefix" {
  default     = ""
  description = "The prefix of the parameters this role should be able to access"
}
