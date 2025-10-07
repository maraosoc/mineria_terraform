output "instance_id" {
  value = aws_instance.box.id
}

output "availability_zone" {
  value = aws_instance.box.availability_zone
}

# Comando listo para conectarse por SSM
output "ssm_command" {
  value = "aws ssm start-session --target ${aws_instance.box.id} --profile ${var.profile} --region ${var.region}"
}
