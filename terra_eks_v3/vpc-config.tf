data "aws_availability_zones" "available" { }


resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr["A"]}.${var.cidr["B"]}.${var.cidr["C"]}.${var.cidr["D"]}/${var.cidr["NET"]}" 

  tags = {
      "Name"                                      = var.vpc_name
      "Kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# NOTE: "Kubernetes.io/cluster/${var.cluster-name}" tags are required for EKS and K8s to discover and manage networking resources.




resource "aws_subnet" "subnet" {
    count = var.subnet_count
    
    availability_zone = data.aws_availability_zones.available.names[count.index]
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = "${var.cidr["A"]}.${var.cidr["B"]}.${count.index}.${var.cidr["D"]}/${var.subnet_netbit}"
    
    

    tags = {
      "Name"                                      = "${var.subnet_name}=${count.index}"
      "Kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
      Name = var.igw_name
  }
}

resource "aws_route_table" "rt-table" {
  vpc_id = aws_vpc.vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt-table-assn" {
  count = var.subnet_count

  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.rt-table.id
}

