

# Opción simple (usa ~/.kube/config dentro del contenedor Jenkins)
provider "kubernetes" {}

# --- Si prefieres ruta explícita, usa ESTA forma (no las dos) ---
# provider "kubernetes" {
#   config_path = pathexpand(var.kubeconfig_path)
# }