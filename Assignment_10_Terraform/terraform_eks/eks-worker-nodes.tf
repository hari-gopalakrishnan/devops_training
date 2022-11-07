#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "hari-node" {
  name = "terraform-eks-hari-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "hari-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.hari-node.name
}

resource "aws_iam_role_policy_attachment" "hari-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.hari-node.name
}

resource "aws_iam_role_policy_attachment" "hari-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.hari-node.name
}

resource "aws_eks_node_group" "hari" {
  cluster_name    = aws_eks_cluster.hari.name
  node_group_name = "hari"
  node_role_arn   = aws_iam_role.hari-node.arn
  subnet_ids      = aws_subnet.hari[*].id
  disk_size  	  = 10
  instance_types  = ["t2.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.hari-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.hari-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.hari-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
