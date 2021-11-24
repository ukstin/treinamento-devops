provider "aws" {
  region = "sa-east-1"
}


resource "aws_instance" "maquina_master" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.2xlarge"
  key_name      = "privatekey_mysql_uk"
  subnet_id     = "subnet-08fb0f3d30afab93d"
  tags = {
    Name = "k8s-master-desafio"
  }
  root_block_device {
    encrypted   = true
    volume_size = 8
  }
  vpc_security_group_ids = [aws_security_group.acessos_master_single_master.id]
  depends_on = [
    aws_instance.workers,
  ]
}

resource "aws_instance" "workers" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.large"
  key_name      = "privatekey_mysql_uk"
  subnet_id     = "subnet-092b12a9fa786bdef"
  tags = {
    Name = "k8s-node-desafio-${count.index}"
  }
  root_block_device {
    encrypted   = true
    volume_size = 8
  }
  vpc_security_group_ids = [aws_security_group.acessos_workers_single_master.id]
  count                  = 3
}

resource "aws_security_group" "acessos_master_single_master" {
  name        = "acessos_master_single_master_desafio"
  description = "acessos_workers_single_master inbound traffic"
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
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 65535
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
    Name = "acessos_master_single_master"
  }
}

resource "aws_security_group" "acessos_workers_single_master" {
  name        = "acessos_workers_single_master_desafio"
  description = "acessos_workers_single_master inbound traffic"
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
    }
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
    Name = "acessos_workers_single_master"
  }
}

# terraform refresh para mostrar o ssh
output "maquina_master" {
  value = [
    "master_node - ${aws_instance.maquina_master.public_ip} - ssh -i ~/.ssh/privatekey_mysql_uk.pem ubuntu@${aws_instance.maquina_master.public_dns}"
  ]
}

# terraform refresh para mostrar o ssh
output "maquina_workers" {
  value = [
    for key, item in aws_instance.workers :
    "worker${key + 1} - ${item.public_ip} - ssh -i ~/ssh/privatekey_mysql_uk.pem ubuntu@${item.public_dns}"
  ]
}

output "security_group_master" {
  value = aws_security_group.acessos_master_single_master.id
}

output "security_group_workers" {
  value = aws_security_group.acessos_workers_single_master.id
}

output "img_deploy_k8s" {
  //value = [
    value = "resource_id: ${aws_instance.maquina_master.id}"
    //"public_ip: ${aws_instance.dev_img_deploy_jenkins.public_ip}",
    //"public_dns: ${aws_instance.dev_img_deploy_jenkins.public_dns}",
    //"ssh -i /var/lib/jenkins/.ssh/privatekey_mysql_uk.pem ubuntu@${aws_instance.dev_img_deploy_jenkins.public_dns}"
  //]
}
