$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$app  = Join-Path $root "app"

if (-not (Get-Command minikube -ErrorAction SilentlyContinue)) {
  throw "minikube no está instalado."
}

# Iniciar minikube si no corre
try { minikube status --profile minikube | Out-Null }
catch { minikube start --cpus=2 --memory=2048 | Out-Null }

if (-not (Test-Path $app)) {
  New-Item -ItemType Directory -Path $app | Out-Null
}
Set-Location $app

# Clonar la app si no existe repo (idempotente)
if (-not (Test-Path (Join-Path $app ".git"))) {
  git clone https://github.com/alexisjimoba/pythonApp.git .
} else {
  git pull
}

Write-Host "Construyendo imagen dentro de Minikube: pythonapp:latest"
minikube image build -t pythonapp:latest .
Write-Host "Imagen lista: pythonapp:latest"
