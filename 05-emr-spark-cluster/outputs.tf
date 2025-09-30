output "cluster_id" {
  value = aws_emr_cluster.this.id
}

# Comando para obtener el InstanceId del master y entrar por SSM
output "get_master_instance_id_cmd" {
  value = "aws emr list-instances --cluster-id ${aws_emr_cluster.this.id} --instance-group-types MASTER --query 'Instances[0].Ec2InstanceId' --output text --profile ${var.profile} --region ${var.region}"
}
