# Cluster Name: This will be reflected in the EKS control plane

variable "cluster-name" {
    default = "terraform-eks-cluster"
    type = string
    description = "Name of the EKS Cluster"

}

# Amazon Machine Image for EKS Deployer
variable "ami-id" {
  default = "ami-064b6506e548c0f32"
  type = string
  description = "Amazon Machine Image"
}

variable "public-subnet" {
    default = "10.0.3.0/24"
    type = string
    description = "public subnet for ec2 instance"
}

variable "key-name"{
  default = "terraDeploy" # Create a new one if it does not exist already
  type = string
  description = "Name of the access key used by EKS Deployment Machine"
}

variable "deployer-instance-type" {
  default  = "t3.medium"
}
