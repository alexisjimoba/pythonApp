param(
  [string]$Namespace = "pythonapp",
  [string]$ReleaseName = "pythonapp",
  [string]$ImageRepository = "pythonapp",
  [string]$ImageTag = "latest",
  [int]$Replicas = 1,
  [string]$ServiceType = "NodePort",
  [int]$NodePort = 30080,
  [bool]$IngressEnabled = $false,
  [string]$IngressHost = "pythonapp.local"
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$tf   = Join-Path $root "terraform"

# 1) Minikube ON
if (-not (Get-Command minikube -ErrorAction SilentlyContinue)) {
  throw "minikube no está instalado."
}
try { minikube status --profile minikube | Out-Null }
catch { minikube start --cpus=2 --memory=2048 | Out-Null }

# 2) KUBECONFIG + contexto
$env:KUBECONFIG = "$HOME\.kube\config"
kubectl config use-context minikube | Out-Null

# 3) Build de imagen interna + clon de app
& "$PSScriptRoot\build_image.ps1"

# 4) Terraform apply con variables
Set-Location $tf
# Exportar variables para Terraform si se desean (opcional)
$env:TF_VAR_namespace = $Namespace
$env:TF_VAR_release_name = $ReleaseName
$env:TF_VAR_image_repository = $ImageRepository
$env:TF_VAR_image_tag = $ImageTag
$env:TF_VAR_replicas = "$Replicas"
$env:TF_VAR_service_type = $ServiceType
$env:TF_VAR_node_port = "$NodePort"
$env:TF_VAR_ingress_enabled = $IngressEnabled.ToString().ToLower()
$env:TF_VAR_ingress_host = $IngressHost

terraform init
terraform apply -auto-approve

# 5) Abrir servicio (NodePort) si corresponde
if ($ServiceType -eq "NodePort") {
  & "$PSScriptRoot\open_service.ps1"
} else {
  Write-Host "Service type = $ServiceType. Omite apertura automática via NodePort."
}
