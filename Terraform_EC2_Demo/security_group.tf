resource "aws_security_group" "WebDMZ" {
    name = var.sg_webdmz_name
    description = "Security Group for EC2 Instance"
    vpc_id = aws_vpc.vpc.id

    egress {  #Outbound Traffic
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }

    ingress {
        from_port = 22
        to_port   = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
 
}

