provider "aws" {
  region = "us-east-1"
}

# Declare the EKS Role ARN variable
variable "eks_role_arn" {
  description = "The ARN of the IAM role that provides permissions for the EKS cluster."
  type        = string
}

# Declare the Subnet IDs variable
variable "subnet_ids" {
  description = "A list of subnet IDs where EKS cluster nodes will be deployed."
  type        = list(string)
}

resource "aws_eks_cluster" "socks_shop" {
  name     = "socks-shop-cluster"
  role_arn = var.eks_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

output "kubeconfig" {
  value = aws_eks_cluster.socks_shop.kubeconfig[0]
}

