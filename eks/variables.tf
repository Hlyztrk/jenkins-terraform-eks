variable "vpc_cidr" {
  type        = string
  description = "EKS VPC"
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "EKS Private Subnets"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "EKS Public Subnets"
}
