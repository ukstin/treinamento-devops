provider "aws" {
  region = "sa-east-1"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com" # outra opção "https://ifconfig.me"
}

resource "aws_instance" "jenkins-uk" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.2xlarge"
  subnet_id     = "subnet-0ed3eafc0cc1414e0"
  key_name      = "privatekey_mysql_uk"
  root_block_device {
    encrypted   = true
    volume_size = 8
  }
  tags = {
    Name = "jenkins-uk"
  }
  vpc_security_group_ids = ["${aws_security_group.jenkins-uk.id}"]
}

resource "aws_security_group" "jenkins-uk" {
  name        = "acessos_jenkins"
  description = "acessos_jenkins inbound traffic"
  vpc_id      = "vpc-0b7bc0aae8788da62"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null,
      security_groups : null,
      self : null
    },
    {
      description      = "SSH from VPC"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null,
      security_groups : null,
      self : null
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids  = null,
      security_groups : null,
      self : null,
      description : "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "jenkins-uk"
  }
}

# terraform refresh para mostrar o ssh
output "jenkins" {
  value = [
    "jenkins",
    "id: ${aws_instance.jenkins-uk.id}",
    "private: ${aws_instance.jenkins-uk.private_ip}",
    "public: ${aws_instance.jenkins-uk.public_ip}",
    "public_dns: ${aws_instance.jenkins-uk.public_dns}",
    "ssh -i ~/.ssh/privatekey_mysql_uk.pem ubuntu@${aws_instance.jenkins-uk.public_dns}"
  ]
}
