# Crea el rol IAM para EC2 con solo los permisos necesarios de SSM
# El rol permite manejar temporalmente las credenciales de uso de la API
resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.name}-ec2-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

# Esta política permite delegar el control operativo de la instancia a un proveedor de servicios (En este caso Terraform)
# Al ser "managed instance" permite que reciba y envie comandos e interactue con otros servicios básicos
# Es el que entrega las credenciales al agente de terraform
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# El instance profile envuelve el rol en el cual recide la instancia EC2
resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "${var.name}-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name
}
