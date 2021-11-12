provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t3.micro"
  key_name                = "keypair_uk" # key chave publica cadastrada na AWS 
  subnet_id               =  aws_subnet.my_subnet.id # vincula a subnet direto e gera o IP automático
  #private_ip              = "172.17.0.100"
  vpc_security_group_ids  = [
    "${aws_security_group.allow_ssh_terraform.id}",
  ]
  root_block_device {
    encrypted = true
    volume_size = 8
  }

  tags = {
    Name = "ec2-uk-public01"
  }
}

#resource "aws_eip" "example" {
#  vpc = true
#}

#resource "aws_eip_association" "eip_assoc" {
#  instance_id   = aws_instance.web.id
#  allocation_id = aws_eip.example.id
#}

# terraform refresh para mostrar o ssh

output "instance_ip_addr" {
  value = [
    aws_instance.web.private_ip,
    "ssh -i ~/Desktop/devops/treinamentoItau ubuntu@${aws_instance.web.private_dns}"
  ]
}
