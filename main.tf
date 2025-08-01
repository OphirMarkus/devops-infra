# Create project VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"
  name    = "ophirs-vpc-v3"
  cidr    = "10.1.0.0/16"

  azs             = ["${var.region}a", "${var.region}b"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = var.tags
}

data "aws_iam_policy_document" "eks_node_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Initiate an EKS cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name             = var.cluster_name
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets
  vpc_id                   = module.vpc.vpc_id

  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    default = {
      desired_size = 1
      max_size     = 2
      min_size     = 1

      instance_types  = var.instance_types
      capacity_type   = "SPOT"
      create_iam_role = true
    }
  }

  tags = var.tags
}