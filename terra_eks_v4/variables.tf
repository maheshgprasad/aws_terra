# VPC Related Configuration Variables
# Contains
# - Region
# - CIDR Block ( VPC )
# - VPC Name
# - VPC Subnet Count
# - VPC Subnet Netbit
# - VPC Subnet Name
# - VPC Internet Gateway Name

# 1 Region
variable "region" {
  type = string
  description = "AWS region to deploy into"
  default = "ap-south-1" #Mumbai Region  
}

# 2 VPC CIDR Block
variable "cidr" {
  type = map(number)
  description = "Classless Inter Domain Routing Blocks"
  default = {
    "A" = 10,
    "B" = 0,
    "C" = 0,
    "D" = 0,
    "NET" = 16
  }
  # the block goes like this A.B.C.D/NET
}

# 3 VPC Name
variable "vpc_name" {
  type = string
  description = "Terraform generated VPC Name" 
  default = "terraform-eks-cluster-vpc"
  
}

# 4 VPC Subnet Count (Number of Subnets required in that VPC)

variable "subnet_count" {
  type = number
  description = "Number of Subnets to be provisioned in the VPC"
  default = 2
  
}

# 5 VPC Subnet (Netbit) 
variable "subnet_netbit" {
  type = number
  description = "Netbit of the subnet to provision"
  default = 24  # Releases a healthy usable 254 Addresses
  # Refer https://cidr.xyz/ for more info
}

# 6 VPC Subnet Name
variable "subnet_name" {
  type = string
  description = "Name of the Subnet"
  default = "terraform-eks-subnet"
  
}

# 6 VPC Internet Gateway Name
variable "igw_name" {
  type = string
  description = " VPC Internet Gateway"
  default = "terraform-eks-igw"
}

# Security Configuration Variables
# 1 SG Cluster Name

variable "security_group_cluster_name" {
  type = string
  description = "Name of the SG for the cluster to worker communication" 
  default = "terraform-eks-cluster-sg"
}
# 2 SG Node Name
variable "security_group_node_name" {
  type = string
  description = "Name of the SG for the node to worker communication" 
  default = "terraform-eks-node-sg"
}

# 2 SG EC2 SSH
variable "security_group_ec2_ssh" {
  type = string
  description = "Name of the SG Worker Node SSH communication" 
  default = "terraform-eks-node-ssh"
}


# EKS Cluster Related Configuaration Variables

# Cluster Name: This will be reflected in the EKS control plane
# 1 EKS Cluster Name
variable "cluster_name" {
    default = "terraform-eks-cluster"
    type = string
    description = "Name of the EKS Cluster"

}

# 2 EKS Cluster IAM role name
variable "iam_eks_node_name" {
  type = string
  description = "EKS Cluster IAM role name"
  default = "terraform-eks-node"
}

# 3 EKS Cluster log types for Cloudwatch
variable "eks_cluster_log_types" {
  type = list(string)
  description = "EKS cluster enables log types to Cloudwatch"
  default = ["scheduler", "controllerManager"]
}

# 4 EKS Cluster IAM Role Name

variable "iam_eks_cluster_name" {
  type = string
  description = "EKS Cluster IAM role name" 
  default = "terraform-eks-cluster"
}

# 5. EKS IAM policy ARN (Set of policies to associate with EKS IAM Role)
variable "iam_eks_cluster_policy_arn" {
  type = list(string)
  description = "List of policies to attach to the EKS Cluster role"
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ]
}

# EKS Worker Configuration Variables

# 1 EKS Node group name
variable "eks_node_group_name" {
  type = string
  description = "EKS Worker node group name" 
  default = "terraform-eks-ng"
}

# 2 EKS Node Worker Instance Type
variable "eks_worker_instance_type" {
  type = list(string)
  description = "EKS Worker instance type" 
  default = ["t3.medium"]
}

# EKS Autoscaling group name
variable "eks_auto_scaling_group_name" {
  type = string
  description = "EKS Auto Scaling Group name" 
  default = "terraform-eks-asg"
}
# EKS Worker Desired Capacity
variable "eks_worker_desired_capacity" {
  type = number
  description = "EKS Worker desired capacity" 
  default = 1
}

# EKS Worker Minimum Number of Nodes
variable "eks_worker_min_size" {
  type = number
  description = "EKS minimum number of nodes" 
  default = 1
}

# EKS Worker Maximum Number of Nodes
variable "eks_worker_max_size" {
  type = number
  description = "EKS maximum number of nodes" 
  default = 1
}

#EKS Worker EC2 SSH Key Name
variable "eks_ec2_ssh_key" {
  type = string
  description = "Used to SSH into the Worker Node Instances"
  default = "terraDeploy"
}

# EKS Worker Nodes SSH CIDR
variable "eks_ec2_ssh_cidr" {
  type = list(string)
  description = "To Enable SSH Access to the Worker Nodes"
  default = ["0.0.0.0/0"]  # Please Change This 
}

# EKS Worker Node Disk Size
variable "eks_ec2_disk_size" {
  type = number
  description = "EC2 Disk Size on the Worker Nodes"
  default = 30
}

# EKS Node Policy arns (PLEASE DO NOT MODIFY - BREAKS FUNCTIONALITY)
variable "iam_eks_node_policy_arn" {
  type = list(string)
  description = "List of policies to attach to the EKS node role"
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
  ]

}

# Deployer Configuration Variables

# 1 Deployer Amazon Machine Image ID
variable "deployer_ami_id" {
  type = string
  description = "Deployer AMI ID"
  default = "ami-0912f71e06545ad88"
}

# 2 Deployer Instance Type
variable "deployer_instance_type" {
  type = string
  description = "Deployer instance type"
  default = "t3.medium"
}

# 3 Deployer Instance Security group name
variable "sg_deployer_name" {
  type = string
  description = "Deployer Instance SG Name"
  default = "security-group-deployer"
}

# 4 Deployer Instance Inbound Traffic CIDR 

variable "eks_deployer_cidr" {
  type = list(string)
  description = "CIDR Block Value for Deployer Instance"
  default = ["0.0.0.0/0"] # AT ANY COST DO NOT LEAVE THIS EXPOSED TO THE WORLD
  
}

# Node Group Remote Access ( AWS-SG: workspace_ssh)

# 1 Workspace IP Addresses 

variable "workspace_ip" {
  type = list(string) 
  description = "CIDR Block Value for the Deployer Instance" 
  default = ["0.0.0.0/0"] # AT ANY COST DO NOT LEAVE THIS EXPOSED TO THE WORLD
}

# 2 Workspace SSH SG Name
variable "workspace_ssh" {
  type = string
  description = "Name of the Workspace SSH SG"
  default = "workspace-node-ssh"
}

