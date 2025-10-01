# Minería Lab: Terraform + AWS

Este repositorio contiene **5 entregables**, para poner el práctica la IaC declarativa con Terraform.

1. `01-ec2-python-pandas`: Instancia EC2 con Python + Pandas
2. `02-ec2-python-polars`: Instancia EC2 con Python + Polars
3. `03-ec2-python-duckdb`: Instancia EC2 con Python + DuckDB
4. `04-ec2-python-spark`: Instancia EC2 con Python + Spark (modo local)
5. `05-emr-spark-cluster`: EMR con Spark distribuido

Cada carpeta incluye:
- Código Terraform listo para `init/plan/apply/destroy`.
- Conexión por SSM.
- **README** con instrucciones para correr el código.
- Carpeta **screenshot** con evidencia de instalación.

---

## Prerrequisitos

- Windows con **AWS CLI v2**, **Session Manager Plugin (SMP)** y **Terraform** instalados.
> Versiones usadas para este laboratorio: AWS - `aws-cli/2.31.3 Python/3.13.7 Windows/11 exe/AMD64`, SMP - `1.2.707.0`, Tarreform - `v1.13.3`
- Autenticación por **SSO**:
  - **SSO session name**: `mineria-sso`
  - **Profile name**: `maraosoc`
  - **Region**: `us-east-2`
  - **Permission set**: *AdministratorAccess*

**Cómo configurar AWS CLI para SSO**:
- Solo una vez
```powershell
aws configure sso
# SSO session name
# SSO start URL: <URL de AWS access portal>
# SSO region: us-east-2
# Loggearse a la cuenta
# Profile name: maraosoc
```
- Después
```
aws sso login --profile maraosoc
```

---

## Estructura

```
mineria-terraform/
├─ .gitignore
├─ README.md
├─ 01-ec2-python-pandas/
├─ 02-ec2-python-polars/
├─ 03-ec2-python-duckdb/
├─ 04-ec2-python-spark/
└─ 05-emr-spark-cluster/
```

---

## Flujo general
En cada carpeta

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
