# Contents of this file In-Order
# AWS VPC Config
# AWS VPC Subnet Config
# VPC Internet Gateway Configuration
# VPC Route Table
# VPC Route Table Association

resource "aws_vpc" "eks-terra-vpc" {
  cidr_block = "10.0.0.0/16"                      # Is the IP CIDR block allocation to the vpc

  tags = {
      "Name"                                      = "eks-terra-vpc-node"
      "Kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

# NOTE: "Kubernetes.io/cluster/${var.cluster-name}" tags are required for EKS and K8s to discover and manage networking resources.

data "aws_availability_zones" "available" { }


resource "aws_subnet" "eks-terra-subnet" {
    count = 2
    
    availability_zone = data.aws_availability_zones.available.names[count.index]
    vpc_id            = aws_vpc.eks-terra-vpc.id
    cidr_block        = "10.0.${count.index}.0/24"
    
    

    tags = {
      "Name"                                      = "eks-terra-vpc-node"
      "Kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}


resource "aws_internet_gateway" "eks-terra-vpc-internet-gateway" {
  vpc_id = aws_vpc.eks-terra-vpc.id

  tags = {
      Name = "eks-terra-vpc"
  }
}

resource "aws_route_table" "eks-terra-vpc-route-table" {
  vpc_id = aws_vpc.eks-terra-vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.eks-terra-vpc-internet-gateway.id
  }
}

resource "aws_route_table_association" "eks-terra-vpc-route-table-assn" {
  count = 2

  subnet_id      = aws_subnet.eks-terra-subnet[count.index].id
  route_table_id = aws_route_table.eks-terra-vpc-route-table.id
}


