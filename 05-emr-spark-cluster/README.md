# EMR + Spark (distribuido)
Acá se construye una instancia EMR para ejecutar Spark distribuido, el cual se puede instalar en una simple línea de código.

## Requisitos previos
- AWS CLI v2 y Session Manager Plugin instalados.
- Perfil SSO válido:
```powershell
aws sso login --profile maraosoc
cd <ruta>\mineria_terraform\05-emr-spark-cluster
$env:AWS_PROFILE    = "maraosoc"
$env:TF_VAR_profile = "maraosoc"
$env:TF_VAR_region  = "us-east-2"
$env:TF_VAR_owner   = "maraosoc"
```

## Pasos
```powershell
terraform init
terraform plan -var="name=emr-spark" -out=emr-spark-plan
terraform apply "emr-spark-plan"
```

## Conexión al **master** por SSM
```powershell
$CLUSTER = $(terraform output -raw cluster_id)
# Verificar estado y disponibilidad de los cluster
do {
  $state = aws emr describe-cluster --cluster-id $CLUSTER `
    --query "Cluster.Status.State" --output text --region us-east-2 --profile maraosoc
  Write-Host "Estado del cluster: $state"
  if ($state -in @("WAITING","RUNNING")) { break }
  Start-Sleep -Seconds 30
} while ($true)
# Conectarse por SSM al master node
$MASTER  = aws emr list-instances --cluster-id $CLUSTER --instance-group-types MASTER --query "Instances[0].Ec2InstanceId" --output text --profile maraosoc --region us-east-2

aws ssm start-session --target $MASTER --profile maraosoc --region us-east-2
```

## Verificación
Dentro del master:
```bash
spark-submit --version
pyspark --version
```
## Finalización
Para no incurrir en costos adicionales, finaliza la sessión con `exit` y después en la consola:
```powershell
terraform destroy -auto-approve -var="name=emr-spark"
```
# Evidencias

---
## Evidencia de creación de la instancia EC2

A continuación se muestran dos imágenes, la de la izquierda es la consola con la aplicación del plan y la de la derecha muestra la instancia correctamente creada en aws.

<div style="display: flex; gap: 10px;">
    <img src="screenshot/Captura de pantalla 2025-10-10 084429.png" alt="EC2 Creada - consola" width="45%" />
    <img src="screenshot/Captura de pantalla 2025-10-10 084451.png" alt="EC2 Creada - aws" width="45%" />
</div>

---
## Evidencia de instalación de spark

La siguiente imagen muestra la versión de spark instalada en la instancia EC2:

<img src="screenshot/Captura de pantalla 2025-10-10 090729.png" alt="Versión de spark instalada" width="50%" />