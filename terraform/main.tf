provider "kubernetes" {
  config_path    = pathexpand("~/.kube/config")
  config_context = "minikube"
}

provider "helm" {
  kubernetes {
    config_path    = pathexpand("~/.kube/config")
    config_context = "minikube"
  }
}

resource "kubernetes_namespace" "ns" {
  metadata { name = var.namespace }
}

output "namespace" {
  value = kubernetes_namespace.ns.metadata[0].name
}
