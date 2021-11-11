variable "subnet_id" {
  type = string
  validation {
    condition = substr(var.subnet_id,0,7) == "subnet-"
    error_message = "O valor da subnet_id não eh valido!"
  }
}
variable "ami" {
  type = string
  validation {
    condition = substr(var.ami,0,4) == "ami-"
    error_message = "AMI invalida!"
  }
}
variable "instance_type" {
  type = string
  validation {
    condition = var.instance_type == "t2.micro"
    error_message = "Instancia invalida!"
  }
}
variable "vpc_security_group_ids" {
  type = string
  validation {
    condition = substr(var.vpc_security_group_ids,0,3) == "sg-"
    error_message = "Security Group Invalido!"
  }
}