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
  value = <<EOT
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.socks_shop.endpoint}
    certificate-authority-data: ${aws_eks_cluster.socks_shop.certificate_authority[0].data}
  name: ${aws_eks_cluster.socks_shop.name}
contexts:
- context:
    cluster: ${aws_eks_cluster.socks_shop.name}
    user: aws
  name: ${aws_eks_cluster.socks_shop.name}
current-context: ${aws_eks_cluster.socks_shop.name}
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${aws_eks_cluster.socks_shop.name}"
EOT
}




