# (opcional) crear el namespace aquí; si ya existe en otro archivo, elimina este bloque
resource "kubernetes_namespace" "ns" {
  metadata { name = var.namespace }
}

resource "helm_release" "pythonapp" {
  name      = var.release_name
  chart     = abspath("${path.module}/${var.chart_path}")
  namespace = kubernetes_namespace.ns.metadata[0].name
  create_namespace = false
  depends_on       = [kubernetes_namespace.ns]

  values = [
    yamlencode({
      image = {
        repository = var.image_repository
        tag        = var.image_tag
      }
      replicaCount = var.replicas
      service = {
        type     = var.service_type
        nodePort = var.node_port
      }
      resources = {
        limits = {
          cpu    = var.cpu_limit
          memory = var.mem_limit
        }
        requests = {
          cpu    = var.cpu_request
          memory = var.mem_request
        }
      }
      ingress = {
        enabled = var.ingress_enabled
        hosts = [{
          host  = var.ingress_host
          paths = [{
            path     = "/"
            pathType = "Prefix"
          }]
        }]
      }
    })
  ]
}
