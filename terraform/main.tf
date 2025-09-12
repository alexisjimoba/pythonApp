############################################
# main.tf — Providers (kube + helm)
# - Jenkins inyecta TF_VAR_kubeconfig_path con la
#   ruta del kubeconfig (credencial Secret file).
# - Para uso local, por defecto usa ~/.kube/config
############################################

variable "kubeconfig_path" {
  type        = string
  description = "Ruta al kubeconfig a usar por los providers"
  default     = pathexpand("~/.kube/config")
}

# Provider de Kubernetes
provider "kubernetes" {
  config_path = var.kubeconfig_path
}

# Provider de Helm (usa el mismo kubeconfig)
provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

# Nota:
# - No declares aquí 'terraform { required_providers { ... } }'.
#   Eso debe vivir en versions.tf para evitar duplicados.
# - Los recursos (namespace, helm_release, etc.) van en otros .tf (p.ej. k8s.tf).
