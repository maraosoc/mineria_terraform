# AMI de Amazon Linux 2023 (x86_64) con SSM Agent preinstalado
data "aws_ami" "al2023" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "box" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = element(data.aws_subnet_ids.default.ids, 0)
  vpc_security_group_ids = [aws_security_group.egress_only.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm_profile.name

  # Instalación automática vía user_data (ver archivo user_data.sh)
  user_data              = file("${path.module}/user_data.sh")

  tags = {
    Name  = var.name
    Stack = "ec2-single"
  }
}
