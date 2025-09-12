############################################
# main.tf (completo)
############################################
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
