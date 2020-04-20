# This file contains the basic configuration required for the creation of a control plane cluster.
# Cluster IAM ROLE

resource "aws_iam_role" "iam-eks-cluster" {
    name = var.iam_eks_cluster_name

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": ["eks.amazonaws.com", "ec2.amazonaws.com", "acm.amazonaws.com"]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

# IAM Policy attachment to the cluster
resource "aws_iam_role_policy_attachment" "iam-policy-eks-cluster" {
 count = length(var.iam_eks_cluster_policy_arn)

 policy_arn = var.iam_eks_cluster_policy_arn[count.index]
 role       = aws_iam_role.iam-eks-cluster.name 
}

# Cluster Creation

resource "aws_eks_cluster" "eks" {
    name = var.cluster_name
    role_arn = aws_iam_role.iam-eks-node.arn
    enabled_cluster_log_types = var.eks_cluster_log_types

    vpc_config {
        security_group_ids = [aws_security_group.security-group-cluster.id]
        subnet_ids         = aws_subnet.subnet.*.id
    }

    depends_on = [
        aws_iam_role_policy_attachment.iam-policy-eks-node
    ]
  
}
