variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for tagging"
  default     = "strapi"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}



variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.small"
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  default     = "ami-0ecb62995f68bb549"
}

variable "key_name" {
  description = "Name of the existing AWS Key Pair"
  default     = "FirstKeyValuePair" # use the name you created in AWS
}
