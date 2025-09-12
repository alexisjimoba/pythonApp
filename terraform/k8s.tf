# Si no lo tienes ya:
resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "pythonapp" {
  name             = var.release_name
  # Chart local: resolvemos ruta absoluta desde el módulo
  chart            = abspath("${path.module}/${var.chart_path}")

  namespace        = kubernetes_namespace.ns.metadata[0].name
  create_namespace = false
  depends_on       = [kubernetes_namespace.ns]

  set {
    name  = "image.repository"
    value = var.image_repository
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  set {
    name  = "replicaCount"
    value = tostring(var.replicas)
  }

  set {
    name  = "service.type"
    value = var.service_type
  }

  set {
    name  = "service.nodePort"
    value = tostring(var.node_port)
  }

  set {
    name  = "resources.limits.cpu"
    value = var.cpu_limit
  }

  set {
    name  = "resources.limits.memory"
    value = var.mem_limit
  }

  set {
    name  = "resources.requests.cpu"
    value = var.cpu_request
  }

  set {
    name  = "resources.requests.memory"
    value = var.mem_request
  }

  set {
    name  = "ingress.enabled"
    value = tostring(var.ingress_enabled) # Helm espera string "true"/"false"
  }

  set {
    name  = "ingress.hosts[0].host"
    value = var.ingress_host
  }

  set {
    name  = "ingress.hosts[0].paths[0].path"
    value = "/"
  }

  set {
    name  = "ingress.hosts[0].paths[0].pathType"
    value = "Prefix"
  }
}
