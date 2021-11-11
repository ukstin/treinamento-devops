provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0e66f5495b4efdd0f"
  instance_type = "t2.micro"
  key_name = "privatekey_mysql_uk" # Nome da Key gerada pelo ssk-keygem e upada na AWS
  subnet_id = "subnet-056d64485d6e25ed6"
  associate_public_ip_address = true
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  tags = {
    Name = "ec2-terraform-uk-sg"
  }
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
}
output "instance_ip_addr" {
  value = [aws_instance.web.private_ip, aws_instance.web.public_ip]
  description = "Mostra os IPs publicos e privados da maquina criada."
}