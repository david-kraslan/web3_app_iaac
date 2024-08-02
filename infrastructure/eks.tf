resource "aws_eks_cluster" "web3_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_service_role.arn

  vpc_config {
    subnet_ids = aws_subnet.public-subnet[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.iam-policy-eks-service-attachment,
  ]
}

resource "aws_eks_node_group" "web3_node_group" {
  cluster_name    = aws_eks_cluster.web3_cluster.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.public-subnet[*].id

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 4
  }

  depends_on = [
    aws_iam_role_policy_attachment.iam-policy-eks-node-attachment,
  ]
}


