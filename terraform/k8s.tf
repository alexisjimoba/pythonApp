variable "chart_path" {
  type        = string
  description = "Ruta local del chart Helm"
  default     = "../helm/pythonapp"
}

resource "helm_release" "pythonapp" {
  name       = var.release_name
  repository = ""
  chart      = var.chart_path
  namespace  = kubernetes_namespace.ns.metadata[0].name

  set { name = "image.repository"  value = var.image_repository }
  set { name = "image.tag"         value = var.image_tag }
  set { name = "replicaCount"      value = var.replicas }
  set { name = "service.type"      value = var.service_type }
  set { name = "service.nodePort"  value = var.node_port }
  set { name = "resources.limits.cpu"    value = var.cpu_limit }
  set { name = "resources.limits.memory" value = var.mem_limit }
  set { name = "resources.requests.cpu"  value = var.cpu_request }
  set { name = "resources.requests.memory" value = var.mem_request }
  set { name = "ingress.enabled"   value = var.ingress_enabled }
  set { name = "ingress.hosts[0].host" value = var.ingress_host }
  set { name = "ingress.hosts[0].paths[0].path" value = "/" }
  set { name = "ingress.hosts[0].paths[0].pathType" value = "Prefix" }
}
