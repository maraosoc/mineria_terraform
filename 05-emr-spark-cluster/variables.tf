# Variables base
variable "region"  {"type" = string, "default" = "us-east-2"}
variable "profile" {"type" = string, "default" = "maraosoc"}
variable "owner"   {"type" = string, "default" = "maraosoc"}

# Identidad del cluster
variable "name" {
  type        = string
  default     = "emr-spark-mineria"
  description = "Nombre base para los recursos del cluster EMR"
}

# Parámetros de EMR
variable "release_label" {
  type        = string
  default     = "emr-7.2.0" # Ajusta si necesitas otra versión
  description = "Versión de EMR (ej. emr-7.2.0)"
}

variable "master_instance_type" {
  type        = string
  default     = "m5.xlarge"
}

variable "core_instance_type" {
  type        = string
  default     = "m5.xlarge"
}

variable "core_instance_count" {
  type        = number
  default     = 2
}

# SSH key opcional (SSM es el método recomendado)
variable "key_name" {
  type        = string
  default     = null
}
