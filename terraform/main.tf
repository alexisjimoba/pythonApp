# Providers con TLS desactivado (insecure) y kubeconfig desde variable
provider "kubernetes" {
  load_config_file = true
  config_path      = pathexpand(var.kubeconfig_path)
  insecure         = var.kube_insecure
}

provider "helm" {
  kubernetes {
    load_config_file = true
    config_path      = pathexpand(var.kubeconfig_path)
    insecure         = var.kube_insecure
  }
}