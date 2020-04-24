resource "aws_instance" "deployer" {
  ami           = var.deployer_ami_id
  instance_type = var.deployer_instance_type
  subnet_id     = aws_subnet.subnet[0].id
  key_name      = var.eks_ec2_ssh_key
  vpc_security_group_ids = [aws_security_group.security-group-deployer.id]
  root_block_device {
      volume_size = 30
      volume_type = "gp2"
      delete_on_termination = true
  }
  associate_public_ip_address = true

  depends_on    = [aws_subnet.subnet]

  tags = {
    Name = "EKS MGMNT Deployer"
  }
}



resource "aws_security_group" "security-group-deployer" {
  name = var.sg_deployer_name
  description = "SG for SSH Communication to EKS deployer"
  vpc_id = aws_vpc.vpc.id

  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = var.eks_deployer_cidr
    }

  tags = {
      Name = var.sg_deployer_name
  }

}


