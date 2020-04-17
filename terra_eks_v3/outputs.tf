locals {
    config_map_aws_auth = <<CONFIGMAPAWSAUTH

apiVersion: v1
kind: ConfigMap
metadata:
    name: aws-auth
    namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.eks-terra-node-iam-role.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

    kubeconfig = <<KUBECONFIG

apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks-terra-cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks-terra-cluster.certificate_authority.0.data}
  name: Kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster-name}"
KUBECONFIG

}

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
  description = "Maps the Worker nodes to the Cluster Control Plane"
}

output "kubeconfig" {
    value = local.kubeconfig
    description = "Kubernetes Configuration to connect to the cluster from the management server"
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks-terra-cluster.endpoint
  description = "Cluster End Point"
}

output "eks_deployer_public_ip" {
  value = aws_eip.deployer-eip.public_ip
  description = "EKS Deployment Machine IP address"
}



