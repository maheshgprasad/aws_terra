variable "ec2_ami" {
  type = string
  description = "Amazon Machine Image Reference"
  default = "ami-0912f71e06545ad88"
}

variable "ec2_instance_type" {
    type = string
    default = "t2.micro"  
}

variable "ec2_key_name" {
    type = string
    default = "terraDeploy"
  
}

variable "ec2_volume_size" {
    type = number
    description = "Instance Volume Size"
    default = 20  
}

variable "ec2_volume_type" {
    type = string
    description = "Root Block Volume Type : Default gp2"
    default= "gp2"
  
}

variable "sg_webdmz_name" {
    type = string
    default = "WEB-DMZ"  
}

# VPC Related Variables

variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
}

variable "subnet_count" {
  type = number
  default = 2
}

variable "s_cidr" {
    type = map(number)
    default = {
    "A" = 10,
    "B" = 0,
    "C" = 0,
    "D" = 0,
    "NET" = 24
    }
     
}
