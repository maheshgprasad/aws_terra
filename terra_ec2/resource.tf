 resource "aws_vpc" "terraform_managed_vpc" {
  cidr_block = ["10.0.0.0/16"]
  instance_tenancy = "shared"
  
  tags = {
    Name = "terraform_managed_vpc"
  }

 }
resource "aws_security_group" "instance" {
  vpc_id = "${aws_vpc.terraform_managed_vpc.vpc_id}"
  name        = "terraform_instance_security_group"
  description = "SSH_ONLY"
  
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    protocol_1 = "allow_ssh"
    protocol_2 = "allow_http"
  }
}

#EBS Volume
resource "aws_ebs_volume" "ebs_terraform_instance_volume_1" {
  availability_zone = "ap-south-1"
  size              = 20

  tags = {
    Name = "root_ebs_volume"
    creator = "terraform"
  }
}
