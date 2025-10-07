# EC2 + SPARK
Acá se construye una instancia EC2 con Amazon Linux 2023 que tiene un agente SSM preinstalado y usamos el script `user_data.sh` para instalar python y *spark*. 


## Requisitos previos
- AWS CLI v2 y Session Manager Plugin instalados.
- Perfil SSO configurado y válido:
```powershell
aws sso login --profile maraosoc
cd <ruta>\mineria_terraform\04-ec2-python-spark
$env:AWS_PROFILE    = "maraosoc"
$env:TF_VAR_profile = "maraosoc"
$env:TF_VAR_region  = "us-east-2"
$env:TF_VAR_owner   = "maraosoc"
```
> Para verificar el inicio de sesión escribe en consola `aws sts get-caller-identity --profile maraosoc`

## Pasos
```powershell
terraform init
terraform plan -var="name=ec2-spark" -out=ec2-spark-plan
terraform apply "ec2-spark-plan"

# Conexión por SSM
aws ssm start-session --target $(terraform output -raw instance_id) --profile maraosoc --region us-east-2
```

## Verificación 
Ejecutar dentro de la sesión SSM:
```bash
python3 -c "from pyspark.sql import SparkSession spark = SparkSession.builder.getOrCreate()
print("Spark version:", spark.version)
spark.stop()
```

## Finalización
Para no incurrir en costos adicionales, finaliza la sessión con `exit` y después en la consola:
```powershell
terraform destroy -auto-approve -var="name=ec2-spark"
```
# Evidencias

---
## Evidencia de creación de la instancia EC2

A continuación se muestran dos imágenes, la de la izquierda es la consola con la aplicación del plan y la de la derecha muestra la instancia correctamente creada en aws.

<div style="display: flex; gap: 10px;">
    <img src="screenshot/Captura de pantalla 2025-10-02 165805.png" alt="EC2 Creada - consola" width="45%" />
    <img src="screenshot/Captura de pantalla 2025-10-06 103008.png" alt="EC2 Creada - aws" width="45%" />
</div>

---
## Evidencia de instalación de spark

La siguiente imagen muestra la versión de spark instalada en la instancia EC2:

<img src="screenshot/Captura de pantalla 2025-10-06 103059.png" alt="Versión de spark instalada" width="50%" />

