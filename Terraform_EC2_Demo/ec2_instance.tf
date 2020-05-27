resource "aws_instance" "ec2" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  subnet_id = aws_subnet.subnet[0].id
  key_name = var.ec2_key_name
  vpc_security_group_ids = [aws_security_group.WebDMZ.id]

  root_block_device {
      volume_size = var.ec2_volume_size # GiB
      volume_type = var.ec2_volume_type
      delete_on_termination = true
  }

  tags = {
    Name = "terraform instance"
  }

  depends_on = [aws_subnet.subnet]
}
