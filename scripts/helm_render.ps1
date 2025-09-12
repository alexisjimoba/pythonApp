$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$chart = Join-Path $root "helm\pythonapp"

if (-not (Get-Command helm -ErrorAction SilentlyContinue)) {
  throw "helm no está instalado."
}

helm lint $chart
helm template pythonapp $chart `
  --set image.repository=pythonapp `
  --set image.tag=latest `
  --set service.type=NodePort `
  --set service.nodePort=30080 | Out-File -FilePath (Join-Path $root "helm_render.yaml")

Write-Host "Plantillas renderizadas -> helm_render.yaml"
