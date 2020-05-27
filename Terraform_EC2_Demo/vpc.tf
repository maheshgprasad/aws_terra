data "aws_availability_zones" "available" { }

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block

    tags = {
        Name = "Terraform VPC"
    } 

}

resource "aws_subnet" "subnet" {
    count = var.subnet_count

    availability_zone = data.aws_availability_zones.available.names[count.index]
    vpc_id = aws_vpc.vpc.id
    cidr_block = "${var.s_cidr["A"]}.${var.s_cidr["B"]}.${count.index}.${var.s_cidr["D"]}/${var.s_cidr["NET"]}"
    map_public_ip_on_launch = true
  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
  
}

resource "aws_route_table" "rt-table" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  
}

resource "aws_route_table_association" "name" {
    count = var.subnet_count
    subnet_id = aws_subnet.subnet[count.index].id
    route_table_id = aws_route_table.rt-table.id
  
}
