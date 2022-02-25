# Information about the SG and Its Corresponding Rule Association
# Security Group Cluster 
# - security-group-role-https           :P: 1025-65535 : Ingress : C to N
# - security-group-role-https           :P: 443        : Ingress : C to N
# Security Group Node 
# - security-group-role-node            :P: 0-65535    : Ingress : N to N
# - security-group-role-ec2-ssh         :P: 22         : Ingress : D to N
# - security-group-role-workspace-comm  :P: 1025-65535 : Ingress : E to N
# - security-group-role-workspace-ssh   :P: 22         : Ingress : E to N
# - security-group-role-workspace-http  :P: 80         : Ingress : E to N
# - security-group-role-workspace-https :P: 443        : Ingress : E to N

# C = Cluster | N = Node | D = Deployer | E = External NW


# Cluster Security Group Configuration

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

# Node Security group Configuration

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

# Deployer machine to Nodes SSH Communication

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


# Workspace to Node TCP Communication SG

resource "aws_security_group" "workspace-ssh" {
  name = var.workspace_ssh
  description = "SG for Enabling SSH Communication to Nodes from Workspace"
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.workspace_ssh
  }
}




# Adding Rules to the security groups

# Node to Node Communication Rule (Internal)

resource "aws_security_group_rule" "security-group-role-node" {
    description              = "Allow Nodes to communicate with each other"
    from_port                = 0
    protocol                 = "-1"
    security_group_id        = aws_security_group.security-group-node.id
    source_security_group_id = aws_security_group.security-group-node.id
    to_port                  = 65535
    type                     = "ingress"
}

# Node to Control plane Communication Rule (Node to Cluster)
resource "aws_security_group_rule" "security-group-role-cluster" {
    description              = "Allows Workers to communicate with the EKS Control Plane"
    from_port                = 1025
    protocol                 = "tcp"
    security_group_id        = aws_security_group.security-group-node.id
    source_security_group_id = aws_security_group.security-group-cluster.id
    to_port                  = 65535
    type                     = "ingress"
}

# Cluster to Node Kube API Access Rule HTTPS

resource "aws_security_group_rule" "security-group-role-https" {
    description              = "Allows pods to communicate with the Kube API Server"
    from_port                = 443
    protocol                 = "tcp"
    security_group_id        = aws_security_group.security-group-cluster.id
    source_security_group_id = aws_security_group.security-group-node.id
    to_port                  = 443
    type                     = "ingress"
}

# Deployer to Node SSH Communication

resource "aws_security_group_rule" "security-group-role-ec2-ssh" {
    description              = "Allows EC2 Access from external deployer machine"
    from_port                = 22
    protocol                 = "tcp"
    security_group_id        = aws_security_group.security-group-ec2-ssh.id
    source_security_group_id = aws_security_group.security-group-node.id
    to_port                  = 22
    type                     = "ingress"
  
}

# Node Group Rule to Workspace Communication

resource "aws_security_group_rule" "security-group-role-workspace-comm" {
  description                = "Allows Traffic To and From the Workspace to The Nodes"
  from_port                  = 1025
  protocol                   = "tcp"
  security_group_id          = aws_security_group.security-group-node.id
  cidr_blocks                = var.workspace_ip
  to_port                    = 65535
  type                       = "ingress"
}


resource "aws_security_group_rule" "security-group-role-workspace-ssh" {
  description                = "Allows SSH From the Workspace to The Nodes"
  from_port                  = 22
  protocol                   = "tcp"
  security_group_id          = aws_security_group.workspace-ssh.id
  cidr_blocks                = var.workspace_ip
  to_port                    = 22
  type                       = "ingress"  
}

resource "aws_security_group_rule" "security-group-role-workspace-http" {
  description                = "Allows HTTP Traffic To and From the Workspace to The Nodes"
  from_port                  = 80
  protocol                   = "tcp"
  security_group_id          = aws_security_group.security-group-node.id
  cidr_blocks                = var.workspace_ip
  to_port                    = 80
  type                       = "ingress"  
}

resource "aws_security_group_rule" "security-group-role-workspace-https" {
  description                = "Allows HTTPS Traffic To and From the Workspace to The Nodes"
  from_port                  = 443
  protocol                   = "tcp"
  security_group_id          = aws_security_group.security-group-node.id
  cidr_blocks                = var.workspace_ip
  to_port                    = 443
  type                       = "ingress"  
}