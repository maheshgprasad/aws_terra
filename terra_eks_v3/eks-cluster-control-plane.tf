# This file contains the basic configuration required for the creation of a control plane cluster.
resource "aws_eks_cluster" "eks-terra-cluster" {
    name     = var.cluster-name
    role_arn = aws_iam_role.eks-terra-node-iam-role.arn

    vpc_config {
        security_group_ids = [aws_security_group.eks-terra-cluster-security-group.id]
        subnet_ids         = aws_subnet.eks-terra-subnet[*].id
        
    }

    depends_on = [
        aws_iam_role_policy_attachment.terraform-eks-cluster-AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.terraform-eks-cluster-AmazonEKSServicePolicy,
    ]  
}
