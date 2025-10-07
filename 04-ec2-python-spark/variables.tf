# Variables base del proyecto
variable "region"  {
  type = string 
  default = "us-east-2"
  }
variable "profile" {
  type = string
  default = "maraosoc"
  }
variable "owner"   {
  type = string
  default = "maraosoc"
  }

# Identidad del stack (para nombres únicos)
variable "name" {
  type        = string
  default     = "lab_04"
  description = "Nombre base para recursos (etiquetas, SG, perfiles, etc.)"
}

# Tipo de instancia
variable "instance_type" {
  type        = string
  default     = "t3.medium"
  description = "Tipo de instancia EC2 (t2.micro/t3.micro, etc.)"
}
