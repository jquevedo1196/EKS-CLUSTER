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

variable "cluster_name" {
  description = "Nombre del cluster a crear"
  type        = string
}

variable "cluster" {
  type = object({
    key    = string
    value = string
  })

  default = {
    key = "kubernetes.io/cluster/"
    value = "shared"
  }
}

variable "nets_public" {
  type = object({
    key    = string
    value = number
  })

  default = {
    key = "kubernetes.io/role/elb"
    value = 1
  }
}

variable "nets_private" {
  type = object({
    key    = string
    value = number
  })

  default = {
    key = "kubernetes.io/role/internal-elb"
    value = 1
  }
}


variable "subn_priv_1" {
  description = "ARN de la subnet privada 1"
  type        = string
}

variable "subn_priv_2" {
  description = "ARN de la subnet privada 2"
  type        = string
}

variable "subn_pub_1" {
  description = "ARN de la subnet publica 1"
  type        = string
}

variable "subn_pub_2" {
  description = "ARN de la subnet publica 2"
  type        = string
}