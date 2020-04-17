The EKS service does not provide a cluster-level API parameter or resource to automatically configure the underlying Kubernetes cluster to allow worker nodes to join the cluster via AWS IAM role authentication.

To output an example IAM Role authentication ConfigMap from your Terraform configuration:

locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.demo-node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

}

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

Run terraform output config_map_aws_auth and save the configuration into a file, e.g. config_map_aws_auth.yaml
Run kubectl apply -f config_map_aws_auth.yaml
You can verify the worker nodes are joining the cluster via: kubectl get nodes --watch
At this point, you should be able to use Kubernetes as expected!

