variable "vpc_cidr" {
  type        = string
  description = "Main VPC"
}


variable "public_subnets" {
  type        = list(string)
  description = "Public subnets"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
}

