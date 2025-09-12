# main.tf — solo providers
variable "kubeconfig_path" {
  type        = string
  description = "Ruta al kubeconfig a usar por los providers"
  default     = "~/.kube/config"
}

provider "kubernetes" {
  config_path = pathexpand(var.kubeconfig_path)
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kubeconfig_path)
  }
}


