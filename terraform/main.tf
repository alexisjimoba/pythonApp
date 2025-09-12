############################################
# main.tf (COMPLETO) – Providers sin kubeconfig
############################################

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.32" }
    helm       = { source = "hashicorp/helm",       version = "~> 2.13" }
  }
}

##############################
# Parámetros de despliegue
##############################
variable "namespace"            { type = string  default = "pythonapp" }
variable "release_name"         { type = string  default = "pythonapp" }

variable "image_repository"     { type = string  default = "pythonapp" }
variable "image_tag"            { type = string  default = "latest" }
variable "replicas"             { type = number  default = 1 }

variable "service_type"         { type = string  default = "NodePort" }
variable "node_port"            { type = number  default = 30080 }
variable "service_port"         { type = number  default = 80 }
variable "service_target_port"  { type = number  default = 8000 }

variable "cpu_limit"            { type = string  default = "500m" }
variable "mem_limit"            { type = string  default = "256Mi" }
variable "cpu_request"          { type = string  default = "100m" }
variable "mem_request"          { type = string  default = "128Mi" }

variable "ingress_enabled"      { type = bool    default = false }
variable "ingress_host"         { type = string  default = "pythonapp.local" }

##############################
# Credenciales del cluster (inyectadas como TF_VAR_k8s_*)
##############################
variable "k8s_host"        { type = string } # ej: https://127.0.0.1:xxxxx
variable "k8s_cluster_ca"  { type = string } # base64
variable "k8s_client_cert" { type = string } # base64
variable "k8s_client_key"  { type = string } # base64

##############################
# Providers (sin kubeconfig)
##############################
provider "kubernetes" {
  host                   = var.k8s_host
  cluster_ca_certificate = base64decode(var.k8s_cluster_ca)
  client_certificate     = base64decode(var.k8s_client_cert)
  client_key             = base64decode(var.k8s_client_key)
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = var.k8s_host
    cluster_ca_certificate = base64decode(var.k8s_cluster_ca)
    client_certificate     = base64decode(var.k8s_client_cert)
    client_key             = base64decode(var.k8s_client_key)
    load_config_file       = false
  }
}

##############################
# Recursos
##############################
resource "kubernetes_namespace" "ns" {
  metadata { name = var.namespace }
}

variable "chart_path" {
  type        = string
  description = "Ruta local del chart Helm"
  default     = "../helm/pythonapp"
}

resource "helm_release" "pythonapp" {
  name       = var.release_name
  repository = ""                # usando chart local
  chart      = var.chart_path
  namespace  = kubernetes_namespace.ns.metadata[0].name

  # Pasamos los valores del chart en bloque YAML (evita 'set { }')
  values = [yamlencode({
    replicaCount = var.replicas
    image = {
      repository = var.image_repository
      tag        = var.image_tag
      pullPolicy = "IfNotPresent"
    }
    service = {
      type       = var.service_type
      port       = var.service_port
      targetPort = var.service_target_port
      nodePort   = var.node_port
    }
    resources = {
      limits   = { cpu = var.cpu_limit,   memory = var.mem_limit }
      requests = { cpu = var.cpu_request, memory = var.mem_request }
    }
    ingress = {
      enabled   = var.ingress_enabled
      className = ""
      hosts = [{
        host  = var.ingress_host
        paths = [{ path = "/", pathType = "Prefix" }]
      }]
    }
  })]
}

##############################
# Outputs
##############################
output "namespace" {
  value       = kubernetes_namespace.ns.metadata[0].name
  description = "Namespace utilizado para el despliegue."
}
