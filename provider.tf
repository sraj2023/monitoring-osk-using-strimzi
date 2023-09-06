terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"  # Use the desired version
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.5.0"  # Use the desired version
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"  # Use the desired version
    }
  }
}

provider "kubectl" {
  config_path = "/.kube/config"
}

provider "kubernetes" {
  config_path = "/.kube/config"
}

provider "null" {
  version = "3.1.0"
}

# Define resources as per your original configuration
# ...

