locals {
    config_map_aws_auth = <<CONFIGMAPAWSAUTH

apiVersion: v1
kind: ConfigMap
metadata:
    name: aws-auth
    namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.iam-eks-node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

    kubeconfig = <<KUBECONFIG

apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks.certificate_authority.0.data}
  name: ${var.cluster_name}
contexts:
- context:
    cluster: ${var.cluster_name}
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
      command: aws
      args:
        - "eks"
        - "get-token"
        - "--cluster-name"
        - "${var.cluster_name}"
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


output "deployer_ip" {
  value = aws_instance.deployer.public_ip
  description = "EKS Deployer Machine Public IP Address"
}

