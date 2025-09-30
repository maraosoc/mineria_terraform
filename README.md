# Infra Minería Lab (Terraform + AWS)

Este repositorio contiene **5 entregables** (carpetas independientes de Terraform):

1. `01-ec2-python-pandas`: Instancia EC2 con Python + Pandas
2. `02-ec2-python-polars`: Instancia EC2 con Python + Polars
3. `03-ec2-python-duckdb`: Instancia EC2 con Python + DuckDB
4. `04-ec2-python-spark`: Instancia EC2 con Python + Spark (modo local)
5. `05-emr-spark-cluster`: EMR con Spark distribuido

Cada carpeta incluye:
- Código Terraform listo para `init/plan/apply/destroy`.
- **Conexión por SSM** (sin llaves SSH).
- **README** con instrucciones y comandos de verificación.
- **screenshot.png** de *placeholder* (remplázalo con tu evidencia).

---

## Prerrequisitos

- Windows 11 con **AWS CLI v2**, **Session Manager Plugin** y **Terraform** instalados.
- Autenticación por **SSO** configurada en tu CLI:
  - **SSO session name**: `mineria-sso` (nombre referencial de sesión)
  - **Profile name**: `maraosoc`
  - **Region**: `us-east-2`
  - **Permission set**: *AdministratorAccess* (predefinido de AWS)

Si aún no lo hiciste:
```powershell
aws configure sso
# SSO start URL: <tu access portal URL>
# SSO region: us-east-2
# Selecciona tu cuenta y el permission set AdministratorAccess
# Profile name: maraosoc

aws sso login --profile maraosoc
aws sts get-caller-identity --profile maraosoc
```

---

## Estructura

```
infra-mineria-lab/
├─ .gitignore
├─ README.md
├─ 01-ec2-python-pandas/
├─ 02-ec2-python-polars/
├─ 03-ec2-python-duckdb/
├─ 04-ec2-python-spark/
└─ 05-emr-spark-cluster/
```

---

## Flujo general (en cada carpeta)

```powershell
# Variables de entorno útiles (ajusta si lo necesitas)
$env:AWS_PROFILE    = "maraosoc"
$env:TF_VAR_profile = "maraosoc"
$env:TF_VAR_region  = "us-east-2"
$env:TF_VAR_owner   = "maraosoc"

terraform init
terraform plan -var="name=<nombre-instancia-o-cluster>"
terraform apply -auto-approve -var="name=<nombre-instancia-o-cluster>"

# Conectarte por SSM (EC2)
aws ssm start-session --target <InstanceId> --profile maraosoc --region us-east-2

# EMR (master)
aws emr list-instances --cluster-id <ClusterId> --instance-group-types MASTER --query "Instances[0].Ec2InstanceId" --output text --profile maraosoc --region us-east-2
aws ssm start-session --target <MasterInstanceId> --profile maraosoc --region us-east-2
```
