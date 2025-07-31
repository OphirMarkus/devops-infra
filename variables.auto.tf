variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "ophirs-counter-service"
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.1.101.0/24", "10.1.102.0/24"]
}

variable "tags" {
  type = object({
    project = string
  })
  default = {
    project = "ophirs-counter-service"
  }
}