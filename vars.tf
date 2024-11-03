variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"  
}


variable "vpc_id" {
  type        = string
  default     = "vpc-01b834daa2d67cdaa"
}

variable "cidr_sub_a" {
  type        = string
  default     = "192.168.8.0/24"
}
variable "cidr_sub_b" {
  type        = string
  default     = "192.168.9.0/24"
}


variable "nat_gateway" {
  type        = string
  default     = "nat-0440e3c0e49d26497"
}


variable "internet_gateway" {
  type        = string
  default     = "igw-075b258e232c87f8c"
}


variable "cluster_name" {
  type        = string
  default     = "avihay-cluster"
}


variable "domain_host_id" {
  type        = string
  default     = "Z00269823B8KU0UBQVXPI"
}