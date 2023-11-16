variable "unique_prefix" {
  description = "Name that will be used as prefix for all the resources deployed"
  default     = "panw"
}

provider "aws" {
    region  = var.region
}


variable "region" {
  description = "The AWS region things are created in"
  default = "ap-southeast-1"
}

data "aws_availability_zones" "azs" {
}

variable "ecs_vpc" {
  description = "ECS VPC"
  default     = "10.100.0.0/16"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "2048"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "4096"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "ECSTaskExecutionRole"
}

variable "container_def_path" {
  description = "Container Definition Path"
  default = "./twistlock-console.json"
}