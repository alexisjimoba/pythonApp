# --- Kube / TLS ---
variable "kubeconfig_path" {
  type        = string
  description = "Ruta al kubeconfig que usará Terraform (override con TF_VAR_kubeconfig_path)"
  # En CI lo sobreescribes con una ruta absoluta (p.ej. ${WORKSPACE}/.kube/kubeconfig)
  default     = "~/.kube/config"
}

variable "kube_insecure" {
  type        = bool
  description = "Deshabilitar validación TLS (solo CI/lab)"
  default     = true
}

# --- App / Chart ---
variable "namespace"        { type = string, default = "pythonapp" }
variable "release_name"     { type = string, default = "pythonapp" }
variable "chart_path"       { type = string, default = "../helm/pythonapp", description = "Ruta local del chart Helm (relativa al módulo)" }
variable "image_repository" { type = string, default = "ghcr.io/example/pythonapp" }
variable "image_tag"        { type = string, default = "latest" }
variable "replicas"         { type = number, default = 1 }
variable "service_type"     { type = string, default = "ClusterIP" }
variable "node_port"        { type = number, default = 30080 }
variable "cpu_limit"        { type = string, default = "500m" }
variable "mem_limit"        { type = string, default = "256Mi" }
variable "cpu_request"      { type = string, default = "100m" }
variable "mem_request"      { type = string, default = "128Mi" }
variable "ingress_enabled"  { type = bool,   default = false }
variable "ingress_host"     { type = string, default = "example.local" }