resource "aws_security_group" "security-group-cluster" {
  name = var.security_group_cluster_name
  description = "SG for enabling cluster communication with worker nodes"
  vpc_id = aws_vpc.vpc.id

  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
      Name = var.security_group_cluster_name
  }

}

resource "aws_security_group" "security-group-ec2-ssh" {
  name = var.security_group_ec2_ssh
  description = "SG for SSH Communication to Worker Nodes"
  vpc_id = aws_vpc.vpc.id

  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
      Name = var.security_group_ec2_ssh
  }

}



resource "aws_security_group" "security-group-node" {
    name = var.security_group_node_name
    description = "SG for all the nodes in the cluster"
    vpc_id = aws_vpc.vpc.id

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        "Name"                                      = var.security_group_node_name
        "Kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
}

# Adding Rules to the security groups

resource "aws_security_group_rule" "security-group-role-node" {
    description              = "Allow Nodes to communicate with each other"
    from_port                = 0
    protocol                 = "-1"
    security_group_id        = aws_security_group.security-group-node.id
    source_security_group_id = aws_security_group.security-group-node.id
    to_port                  = 65535
    type                     = "ingress"
}

resource "aws_security_group_rule" "security-group-role-cluster" {
    description              = "Allows Workers to communicate with the EKS Control Plane"
    from_port                = 1025
    protocol                 = "tcp"
    security_group_id        = aws_security_group.security-group-node.id
    source_security_group_id = aws_security_group.security-group-cluster.id
    to_port                  = 65535
    type                     = "ingress"
}

resource "aws_security_group_rule" "security-group-role-https" {
    description              = "Allows pods to communicate with the Kube API Server"
    from_port                = 443
    protocol                 = "tcp"
    security_group_id        = aws_security_group.security-group-cluster.id
    source_security_group_id = aws_security_group.security-group-node.id
    to_port                  = 443
    type                     = "ingress"
}

resource "aws_security_group_rule" "security-group-role-ec2-ssh" {
    description              = "Allows EC2 Access from external deployer machine"
    from_port                = 22
    protocol                 = "tcp"
    security_group_id        = aws_security_group.security-group-ec2-ssh.id
    source_security_group_id = aws_security_group.security-group-node.id
    to_port                  = 22
    type                     = "ingress"
  
}
