# VPC/Subred por defecto
data "aws_vpc" "default" { default = true }
data "aws_subnet_ids" "default" { vpc_id = data.aws_vpc.default.id }

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

# Rol de autoscaling (algunas features lo requieren)
resource "aws_iam_role" "emr_autoscaling" {
  name = "${var.name}-emr-autoscaling-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "application-autoscaling.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "emr_autoscaling_policy" {
  role       = aws_iam_role.emr_autoscaling.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceAutoScalingPolicy"
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
  autoscaling_role = aws_iam_role.emr_autoscaling.arn

  # Red / EC2
  ec2_attributes {
    subnet_id        = element(data.aws_subnet_ids.default.ids, 0)
    instance_profile = aws_iam_instance_profile.emr_ec2_profile.arn
    key_name         = var.key_name
  }

  master_instance_group {
    instance_type  = var.master_instance_type
    instance_count = 1
  }

  core_instance_group {
    instance_type  = var.core_instance_type
    instance_count = var.core_instance_count
  }

  # Etiquetas
  tags = {
    Project = "mineria-lab"
    Owner   = var.owner
  }
}
