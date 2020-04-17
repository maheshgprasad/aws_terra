resource "aws_security_group" "eks-terra-cluster-security-group" {
    name = "eks-terra-cluster-security-group"
    description = "Enables cluster communication with worker nodes"
    vpc_id = aws_vpc.eks-terra-vpc.id

    egress {                           #Egress is responsible for outbound traffic to the cluster.   
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "eks-terra-cluster"
    }
}


# Use this to establish communication with the cluster https services from your deployment machine
resource "aws_security_group_rule" "eks-terra-cluster-ingress-workstation-https" {
   
    description = "Allow Workstation to communicate with the cluster API Server"
    from_port = 443
    protocol = "tcp"
    security_group_id = aws_security_group.eks-terra-cluster-security-group.id
    to_port = 443
    type = "ingress"  
}

