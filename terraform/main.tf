terraform {
  required_version = ">= 1.5.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
  }
}

# Usa ~/.kube/config dentro del contenedor (o KUBECONFIG del entorno)
provider "kubernetes" {}

# Recurso mínimo para validar el plan
resource "kubernetes_namespace" "pythonapp" {
  metadata { name = "pythonapp" }
}
