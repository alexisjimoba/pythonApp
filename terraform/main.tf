############################################
# main.tf (completo)
############################################

# Recibe la ruta al kubeconfig. En Jenkins la sobreescribimos con TF_VAR_kubeconfig_path
variable "kubeconfig_path" {
  description = "Ruta al kubeconfig; usa ~ para el home del usuario."
  type        = string
  default     = "~/.kube/config"
}

locals {
  kubeconfig_expanded = pathexpand(var.kubeconfig_path)
}

provider "kubernetes" {
  config_path    = local.kubeconfig_expanded
  config_context = "minikube"
}

provider "helm" {
  kubernetes {
    config_path    = local.kubeconfig_expanded
    config_context = "minikube"
  }
}

# Namespace donde se instalará la app
resource "kubernetes_namespace" "ns" {
  metadata { name = var.namespace }
}

# Salida útil
output "namespace" {
  value       = kubernetes_namespace.ns.metadata[0].name
  description = "Namespace utilizado para el despliegue."
}
