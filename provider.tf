terraform {
  required_version = "1.4.5"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        #   version = "5.0.0"
    }
    kubernetes = {
        source = "hashicorp/kubernetes"
        version = "2.16.0"
    }
    helm = {
        source = "hashicorp/helm"
        version = "~> 2.9.0"
    }
    kubectl = {
        source = "gavinbunney/kubectl"
        version = "~> 1.14"
    }
  }
}


provider "kubectl" {
  host = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec{
    api_version = "client.authentication.k8s.io/v1beta1"
    command = "aws"
    args = [
        "--region",
        "eu-west-1",
        "eks",
        "get-token",
        "--cluster-name",
        var.cluster_name
    ]
  }
}