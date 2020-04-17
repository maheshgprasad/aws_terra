# Contents of this File 
# Deployment Machine EC2 Instance Related Configuration
# Security Group Configuration for the Deployment Machine
# Security Group Rules associated with the Security Group



resource "aws_instance" "deployer_eks" {
  ami           = var.ami-id

  instance_type = var.deployer-instance-type
  key_name      = var.key-name
  root_block_device {
      volume_type           = "gp2"
      volume_size           = 40
      delete_on_termination = true
    }
  vpc_security_group_ids = [aws_security_group.eks-deployer-security-group.id]
  subnet_id = aws_subnet.eks-deployer-subnet[0].id
  


  tags = {
    Name = "EKS_MGMNT_Deployer"
    
  }
}

# Elastic IP Association to EC2 Instance
resource "aws_eip" "deployer-eip" {
  instance = aws_instance.deployer_eks.id
}


# Security Group Configuration for EKS Deployer Machine

resource "aws_security_group" "eks-deployer-security-group" {
    name = "eks-deployer-security-group"
    description = "Security Group for EKS Management and Deployment machine"
    vpc_id = aws_vpc.eks-terra-vpc.id

    egress {                           #Egress is responsible for outbound traffic to the EC2 Machine.   
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        "Name" =  "eks-cluster-mgmnt-deployer"
    }
}

# Inbound Traffic Configuration for the Deployer Machine
# SG-Rule for allowing deployment machine to communicate with the cluster.
resource "aws_security_group_rule" "eks-deployer-ingress-cluster-https" {
    description              = "Allow Deployer to communicate with the Cluster"
    from_port                = 443
    protocol                 = "tcp"
    security_group_id        = aws_security_group.eks-deployer-security-group.id
    source_security_group_id = aws_security_group.eks-terra-cluster-security-group.id
    to_port = 443
    type = "ingress"  
}

# SG-Rule for allowing communication from the deployment machine to the nodes
resource "aws_security_group_rule" "eks-deployer-ingress-node-ssh" {
    description              = "Allow Deployer to communicate with the Worker Nodes"
    from_port                = 22
    protocol                 = "tcp"
    security_group_id        = aws_security_group.eks-deployer-security-group.id
    source_security_group_id = aws_security_group.eks-terra-node-security-group.id
    to_port                  = 22
    type                     = "ingress"  
}


# SG-Rule for allowing SSH communication from an external source
resource "aws_security_group_rule" "eks-deployer-ssh" {
    description              = "Allow SSH communications to Deployer"
    from_port                = 22
    protocol                 = "tcp"
    security_group_id        =  aws_security_group.eks-deployer-security-group.id
    to_port                  = 22
    type                     = "ingress"  
    cidr_blocks              = ["0.0.0.0/0"]  # modify this field later
}

