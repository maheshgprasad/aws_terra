# resource "aws_vpc" "terraform_ec2_vpc" {
#   cidr_block = "10.0.0.0/16"
# }
resource "aws_security_group" "instance" {
#   vpc_id = "${aws_vpc.terraform_ec2_vpc.id}"
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
    description = "SSH"
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