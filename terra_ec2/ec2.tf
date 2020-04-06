resource "aws_instance" "terra_ec2_isntance01" {
    ami = "ami-0912f71e06545ad88"
    instance_type = "t2.micro"

    tags = {
        Name = "Terraform Created Instance"
        Type = "automated deployment using terraform"
    }
    user_data = <<-EOF
                  #!/bin/bash
                  yum update -y
                  yum install httpd
                  systemctl start httpd.service
                  systemctl enable httpd.service
                  echo "Hello, I am $(hostname -f)" > /var/www/html/index.html
                  EOF

}

