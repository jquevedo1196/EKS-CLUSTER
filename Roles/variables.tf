variable "region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "Perfil de consola para ejecutar el proceso"
  type        = string
  default     = "prod_new"
}

variable "group_name" {
  description = "Nombre del grupo de usuarios"
  type        = string
  default     = "EKS-Managers"
}

variable "user_name" {
  description = "Nombre del usuario manager"
  type        = string
  default     = "EKS-MANAGER"
}

variable "policy_name" {
  description = "Nombre de la política del usuario Manager"
  type        = string
  default     = "AmazonEKSManagerPolicy"
}

variable "policy_file" {
  description = "Archivo de la política del usuario Manager"
  type        = string
  default     = "AmazonEKSManagerPolicy.json"
}