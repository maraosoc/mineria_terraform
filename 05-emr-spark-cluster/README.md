# EMR + Spark (distribuido)

## Requisitos previos
- AWS CLI v2 y Session Manager Plugin instalados.
- Perfil SSO válido:
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
terraform plan -var="name=emr-spark-mineria"
terraform apply -auto-approve -var="name=emr-spark-mineria"
```

## Conexión al **master** por SSM
```powershell
$CLUSTER = $(terraform output -raw cluster_id)
$MASTER  = aws emr list-instances --cluster-id $CLUSTER --instance-group-types MASTER --query "Instances[0].Ec2InstanceId" --output text --profile maraosoc --region us-east-2
aws ssm start-session --target $MASTER --profile maraosoc --region us-east-2
```

## Verificación (pantallazo)
Dentro del master:
```bash
spark-submit --version
pyspark --version
```
Toma captura y reemplaza `screenshot.png`.
