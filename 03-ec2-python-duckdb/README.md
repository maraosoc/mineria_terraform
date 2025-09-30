# EC2 + {STACK_NAME}

## Requisitos previos
- AWS CLI v2 y Session Manager Plugin instalados.
- Perfil SSO configurado y válido:
```powershell
aws sso login --profile maraosoc
$env:AWS_PROFILE    = "maraosoc"
$env:TF_VAR_profile = "maraosoc"
$env:TF_VAR_region  = "us-east-2"
$env:TF_VAR_owner   = "maraosoc"
```

## Pasos
```powershell
terraform init
terraform plan -var="name={NAME_EXAMPLE}"
terraform apply -auto-approve -var="name={NAME_EXAMPLE}"

# Conexión por SSM
aws ssm start-session --target $(terraform output -raw instance_id) --profile maraosoc --region us-east-2
```

## Verificación (pantallazo)
Ejecutar dentro de la sesión SSM y tomar **captura** de la versión:

- {VERIFY_CMD}

Guarda la captura como `screenshot.png` (reemplaza el placeholder incluido).
