############################################
# main.tf — Providers (kube + helm)
# Jenkins puede inyectar TF_VAR_kubeconfig_path.
# Localmente, por defecto usa "~/.kube/config".
############################################

variable "kubeconfig_path" {
  type        = string
  description = "Ruta al kubeconfig a usar por los providers"
  default     = "~/.kube/config"   # ← literal; sin funciones aquí
}

# Provider de Kubernetes
provider "kubernetes" {
  # Aquí sí podemos usar funciones
  config_path = pathexpand(var.kubeconfig_path)
}

# Provider de Helm (usa el mismo kubeconfig)
provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kubeconfig_path)
  }
}

# Nota:
# - 'required_providers' debe estar solo en versions.tf
# - Recursos (ns, helm_release, etc.) en otros .tf (p.ej. k8s.tf)
