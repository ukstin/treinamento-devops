provider "aws" {
  region = "sa-east-1"
}

variable "resource_id" {
  type        = string
  description = "Qual o ID da máquina?"
}

variable "versao" {
  type        = string
  description = "Qual versão da imagem?"
}

resource "aws_ami_from_instance" "ami-k8s" {
  name               = "terraform-k8s-${var.versao}"
  source_instance_id = var.resource_id
}

output "ami" {
  value = [
    "AMI: ${aws_ami_from_instance.ami-k8s.id}"
  ]
}
