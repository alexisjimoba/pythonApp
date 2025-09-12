variable "namespace" {
  type    = string
  default = "pythonapp"
}

variable "release_name" {
  type    = string
  default = "pythonapp"
}

variable "chart_path" {
  type        = string
  description = "Ruta local del chart Helm (relativa al módulo)"
  default     = "../helm/pythonapp"
}

variable "image_repository" {
  type    = string
  default = "ghcr.io/example/pythonapp"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "replicas" {
  type    = number
  default = 1
}

variable "service_type" {
  type    = string
  default = "ClusterIP"
}

variable "node_port" {
  type    = number
  default = 30080
}

variable "cpu_limit" {
  type    = string
  default = "500m"
}

variable "mem_limit" {
  type    = string
  default = "256Mi"
}

variable "cpu_request" {
  type    = string
  default = "100m"
}

variable "mem_request" {
  type    = string
  default = "128Mi"
}

variable "ingress_enabled" {
  type    = bool
  default = false
}

variable "ingress_host" {
  type    = string
  default = "example.local"
}
