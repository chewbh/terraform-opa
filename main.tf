
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.2"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "apps"
}

resource "kubernetes_namespace" "terrform" {
  metadata {
    name = "terrform-ns"
  }
}

resource "kubernetes_pod" "test" {
  metadata {
    name = "terraform-test-pod"
    namespace = "terrform-ns"
  }

  spec {
    container {
      image = "nginx:1.7.8"
      name  = "example"

      env {
        name  = "environment"
        value = "test"
      }

      port {
        container_port = 8080
      }

    }
  }
}

