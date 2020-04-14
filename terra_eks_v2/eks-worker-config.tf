data "aws_ami" "eks-worker" {
  filter {
      name  = "name"
      values = ["amazon-eks-node-${aws_eks_cluster.eks-terra-cluster.version}-v*"]
  }

  most_recent = true
  owners      = ["amazon"]  
}

data "aws_region" "current" {
      
}

locals {
    eks-worker-userdata = <<USERDATA
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks-terra-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks-terra-cluster.certificate_authority[0].data}' '${var.cluster-name}'
    USERDATA
}


resource "aws_launch_configuration" "terra-eks-cluster-launch-configuration" {
  associate_public_ip_address = true
  image_id                    = data.aws_ami.eks-worker.id
  instance_type               = "t3.medium"
  name_prefix                 = "terra-eks"
  security_groups             = [aws_security_group.eks-terra-node-security-group.id]
  user_data                   = base64encode(local.eks-worker-userdata)
  
  lifecycle {
      create_before_destroy = true
  }

  
}

resource "aws_autoscaling_group" "terra-eks-asg" {
    desired_capacity = 1
    launch_configuration = aws_launch_configuration.terra-eks-cluster-launch-configuration.id
    max_size = 1
    min_size = 1
    name = "eks-terra-nodes"
    vpc_zone_identifier = aws_subnet.eks-terra-subnet[*].id

            
    tag {
        key = "Name"
        value = "terraform-eks-node"
        propagate_at_launch = true
    }

    tag {
        key = "kubernetes.io/cluster/${var.cluster-name}"
        value = "owned"
        propagate_at_launch = true
    }
}
