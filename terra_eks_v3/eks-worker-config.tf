# IAM Worker Node Configuration


resource "aws_iam_role" "iam-eks-node" {
    name = var.iam_eks_node_name

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

# IAM Policy attachment to the worker nodes
resource "aws_iam_role_policy_attachment" "iam-policy-eks-node" {
 count = length(var.iam_eks_node_policy_arn)

 policy_arn = var.iam_eks_node_policy_arn[count.index]
 role       = aws_iam_role.iam-eks-node.name 
}

resource "aws_eks_node_group" "eks-worker-node" {
    cluster_name    = aws_eks_cluster.eks.name
    node_group_name = var.eks_node_group_name
    node_role_arn   = aws_iam_role.iam-eks-node.arn
    subnet_ids      = aws_subnet.subnet.*.id


    disk_size       = var.eks_ec2_disk_size #Interms of GiB

    instance_types  = var.eks_worker_instance_type

    remote_access {
        ec2_ssh_key    = var.eks_ec2_ssh_key 
    }
    
    scaling_config {
        desired_size    = var.eks_worker_desired_capacity
        max_size        = var.eks_worker_max_size
        min_size        = var.eks_worker_min_size
    }

    tags = {
        "Name" = var.eks_auto_scaling_group_name
    }

    depends_on = [
        aws_iam_role_policy_attachment.iam-policy-eks-node
    ]
  
}

