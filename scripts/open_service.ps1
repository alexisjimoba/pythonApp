$ErrorActionPreference = "Stop"
# Abre el NodePort en el navegador (Minikube crea un túnel temporal)
minikube service pythonapp -n pythonapp
