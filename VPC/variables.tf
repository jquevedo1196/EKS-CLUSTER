variable "region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "Perfil de consola para ejecutar el proceso"
  type        = string
  default     = "default"
}

variable "cluster_name" {
  description = "Nombre del cluster a crear"
  type        = string
  default     = "Challenge-Cluster"
}