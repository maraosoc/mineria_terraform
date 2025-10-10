# VPC/Subred por defecto
data "aws_vpc" "default" { default = true }
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

#################################
# Roles e Instance Profiles
#################################

# Rol de servicio EMR
resource "aws_iam_role" "emr_service" {
  name = "${var.name}-emr-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "elasticmapreduce.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "emr_service_policy" {
  role       = aws_iam_role.emr_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

# Rol para instancias EC2 del cluster EMR (con SSM)
resource "aws_iam_role" "emr_ec2" {
  name = "${var.name}-emr-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "emr_ec2_policy" {
  role       = aws_iam_role.emr_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "emr_ec2_ssm" {
  role       = aws_iam_role.emr_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "emr_ec2_profile" {
  name = "${var.name}-emr-ec2-profile"
  role = aws_iam_role.emr_ec2.name
}

#################################
# Security Group para EMR (solo egress)
#################################
resource "aws_security_group" "emr_egress_only" {
  name        = "${var.name}-egress-only"
  description = "Permite solo trafico de salida a Internet"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.name}-egress-only"
    Project = "mineria-lab"
    Owner   = var.owner
  }
}

#################################
# EMR Cluster
#################################
resource "aws_emr_cluster" "this" {
  name          = var.name
  release_label = var.release_label
  applications  = ["Spark"]

  # Roles
  service_role     = aws_iam_role.emr_service.arn

  # Red / EC2
  ec2_attributes {
    subnet_id        = element(data.aws_subnets.default.ids, 0)
    instance_profile = aws_iam_instance_profile.emr_ec2_profile.arn
    key_name         = var.key_name
    # Security Group egress only
    emr_managed_master_security_group = aws_security_group.emr_egress_only.id
    emr_managed_slave_security_group  = aws_security_group.emr_egress_only.id
  }

  master_instance_group {
    instance_type  = var.master_instance_type
    instance_count = 1
  }

  core_instance_group {
    instance_type  = var.core_instance_type
    instance_count = var.core_instance_count
  }

  # Autoterminacion
  auto_termination_policy {
  idle_timeout = 900  # segundos -> 15 minutos
  }

  # Etiquetas
  tags = {
    Project = "mineria-lab"
    Owner   = var.owner
  }
}
