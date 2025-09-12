APP_NAME ?= pythonapp

.PHONY: image apply destroy open
image:
	pwsh ./scripts/build_image.ps1

apply:
	cd terraform && terraform init && terraform apply -auto-approve

destroy:
	cd terraform && terraform destroy -auto-approve

open:
	pwsh ./scripts/open_service.ps1
