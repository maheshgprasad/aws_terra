# Role Creation with attachement of policies to the role.
# allows the master | the control plane to manage and retrieve data from other AWS Services.
resource "aws_iam_role" "eks-terra-node-iam-role" {
  name = "eks-terra-node-iam-role"

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "terraform-eks-cluster-AmazonEKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.eks-terra-node-iam-role.name
  
}

resource "aws_iam_role_policy_attachment" "terraform-eks-cluster-AmazonEKSServicePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
    role       = aws_iam_role.eks-terra-node-iam-role.name
  
}

