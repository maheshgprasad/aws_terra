resource "aws_security_group" "eks-terra-node-security-group" {
    name = "eks-node-security-group"
    description = "Security group For all nodes in the cluster"
    vpc_id = aws_vpc.eks-terra-vpc.id

    egress {                           #Egress is responsible for outbound traffic to the cluster.   
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        "Name" =  "eks-terra-cluster-nodes"
        "Kubernetes.io/cluster/${var.cluster-name}" = "owned"
    }
}


# SG-Rule for allowing communication across nodes.
resource "aws_security_group_rule" "eks-terra-node-ingress-self" {
    description = "Allow nodes to communicate with each other"
    from_port = 0
    protocol = "-1"
    security_group_id        = aws_security_group.eks-terra-node-security-group.id
    source_security_group_id = aws_security_group.eks-terra-node-security-group.id
    to_port = 65535
    type = "ingress"  
}

# SG-Rule for allowing communication from the cluster to the nodes
resource "aws_security_group_rule" "eks-terra-node-ingress-cluster" {
    description = "Allow worker kubelets and pods to receive communication"
    from_port = 1025
    protocol = "tcp"
    security_group_id        = aws_security_group.eks-terra-node-security-group.id
    source_security_group_id = aws_security_group.eks-terra-cluster-security-group.id
    to_port = 65535
    type = "ingress"  
}


# SG-Rule for allowing communication from the nodes to the cluster
resource "aws_security_group_rule" "eks-terra-node-ingress-https" {
    description = "Allow worker kubelets and pods to receive communication"
    from_port = 443
    protocol = "tcp"
    security_group_id        =  aws_security_group.eks-terra-cluster-security-group.id
    source_security_group_id =  aws_security_group.eks-terra-node-security-group.id
    to_port = 443
    type = "ingress"  
}