# EC2 + PANDAS
Acá se construye una instancia EC2 con Amazon Linux 2023 que tiene un agente SSM preinstalado y usamos el script de _cloud-init_ `user_data.sh` para instalar pandas. 

## Estructura

```
01-ec2-python-pandas/
├─ provider.tf → configura Terraform y AWS
├─ variables.tf → variables de entrada
├─ networking.tf → VPC por defecto y crea un Security Group solo con egress
├─ iam_ssm.tf → crea IAM Role/Instance Profile con la política AmazonSSMManagedInstanceCore.
├─ main.tf → obtiene la AMI de aws y define la instancia EC2 con user_data
├─ outputs.tf → valores útiles post-apply
└─ user_data.sh → script bash que instala pandas y escribe la versión.
```

## Requisitos previos
- AWS CLI v2 y Session Manager Plugin instalados.
- Perfil SSO configurado y válido:
```powershell
aws sso login --profile maraosoc
cd <ruta>\mineria_terraform\01-ec2-python-pandas
$env:AWS_PROFILE    = "maraosoc"
$env:TF_VAR_profile = "maraosoc"
$env:TF_VAR_region  = "us-east-2"
$env:TF_VAR_owner   = "maraosoc"
```

## Pasos
```powershell
terraform init
terraform plan -var="name=ec2-pandas" -out=ec2-pandas-plan
terraform apply "ec2-pandas-plan"

# Conexión por SSM
aws ssm start-session --target $(terraform output -raw instance_id) --profile maraosoc --region us-east-2
```

## Verificación
Ejecutar dentro de la sesión SSM:
```
python3 -c "import pandas as pd; print(pd.__version__)"
```

## Finalización
Para no incurrir en costos adicionales, finaliza la sessión con `exit` y después en la consola:
```powershell
terraform destroy -auto-approve -var="name=ec2-pandas"
```

# Evidencias

---

## Evidencia de creación de la instancia EC2

A continuación se muestran dos imágenes, la de la izquierda es la consola con la aplicación del plan y la de la derecha muestra la instancia correctamente creada en aws.

<div style="display: flex; gap: 10px;">
	<img src="screenshot/Captura de pantalla 2025-10-01 083509.png" alt="EC2 Creada - consola" width="45%" />
	<img src="screenshot/Captura de pantalla 2025-10-01 083545.png" alt="EC2 Creada - aws" width="45%" />
</div>

---
## Evidencia de instalación de pandas

La siguiente imagen muestra la versión de pandas instalada en la instancia EC2:

<img src="screenshot/Captura de pantalla 2025-10-01 090332.png" alt="Versión de pandas instalada" width="50%" />
