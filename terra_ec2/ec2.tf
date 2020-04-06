resource "aws_instance" "terra_ec2_isntance01" {
    ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform Created Instance"
  }

}