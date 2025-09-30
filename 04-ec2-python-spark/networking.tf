# VPC y subred por defecto para simplificar el laboratorio
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# Security Group: solo salida a Internet (SSM usa conexiones salientes)
resource "aws_security_group" "egress_only" {
  name        = "${var.name}-egress-only"
  description = "Permite solo tráfico de salida"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
