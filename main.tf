provider "aws" {
  region                  = var.region
  shared_credentials_file = "/Users/alex.fernandes/.aws/credentials"
  profile                 = "default"
}

locals {
  cluster_name = "${var.name}-cluster"
}


resource "aws_eks_cluster" "cluster" {
  name     = local.cluster_name
  role_arn = aws_iam_role.eks_role.arn
  version  = "1.15"

  vpc_config {
    subnet_ids = aws_subnet.main[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.name}-workers"
  node_role_arn   = aws_iam_role.worker.arn
  subnet_ids      = aws_subnet.main[*].id
  instance_types  = ["t3a.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_eks_fargate_profile" "main" {
  cluster_name           = aws_eks_cluster.cluster.name
  fargate_profile_name   = "${var.name}-fargate"
  pod_execution_role_arn = aws_iam_role.fargate.arn
  subnet_ids             = aws_subnet.fargate[*].id

  selector {
    namespace = "fargate"
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSFargatePodExecutionRolePolicy,
  ]
}
