# pythonapp-on-minikube-terraform

Despliega https://github.com/alexisjimoba/pythonApp.git en **Minikube** usando **Terraform + Helm**.
Incluye scripts en **PowerShell** y un **Jenkinsfile** para ejecutar todo desde Jenkins.

## Requisitos del agente Jenkins (instalados y en PATH)
- Git
- Minikube
- kubectl
- Terraform (>= 1.5)
- Helm
- PowerShell 5+ o PowerShell 7+ (pwsh)

## Uso rápido en Jenkins
1. Crea un Pipeline en Jenkins con este repositorio/zip como fuente o sube este zip a tu repositorio.
2. Configura un *Windows agent* (o un agente con PowerShell) que tenga Minikube, kubectl, Helm y Terraform instalados.
3. Ejecuta el job con el parámetro `ACTION=deploy` (por defecto). Para destruir, ejecuta con `ACTION=destroy`.

El pipeline hará:
- Checkout del proyecto (este repo)
- Clonar tu app en `app/` desde `https://github.com/alexisjimoba/pythonApp.git`
- Construir imagen Docker dentro de Minikube (`minikube image build`)
- Aplicar Terraform que instala el chart Helm local
- Abrir el servicio con `minikube service`

## Estructura
- `scripts/` PowerShell de build/deploy/open
- `helm/pythonapp` Chart Helm local
- `terraform/` Providers y `helm_release` del chart
- `Jenkinsfile` pipeline declarativo

## Notas
- El Service usa NodePort `30080`. Cambia en `values.yaml` o parámetros del pipeline.
- Si deseas Ingress, habilita el addon: `minikube addons enable ingress` y corre con `INGRESS_ENABLED=true`.
