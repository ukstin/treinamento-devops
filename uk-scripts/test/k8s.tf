// provider "aws" {
//   region = "sa-east-1"
// }

// data "http" "myip" {
//   url = "http://ipv4.icanhazip.com" # outra opção "https://ifconfig.me"
// }

resource "aws_instance" "maquina_master" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.large"
  key_name      = "privatekey_mysql_uk"
  subnet_id     =  aws_subnet.subnet_uk_azC_public.id
  tags = {
    Name = "k8s-master-uk"
  }
  root_block_device {
    encrypted = true
    volume_size = 8
  }  
  vpc_security_group_ids = [aws_security_group.acessos_master_single_master.id]
  depends_on = [
    aws_instance.workers,
  ]
}

resource "aws_instance" "workers" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name      = "privatekey_mysql_uk"
  subnet_id     =  aws_subnet.subnet_uk_azC_public.id
  tags = {
    Name = "k8s-node-uk-${count.index}"
  }
  root_block_device {
    encrypted = true
    volume_size = 8
  }  
  vpc_security_group_ids = [aws_security_group.acessos_workers_single_master.id]
  count         = 3
}

resource "aws_security_group" "acessos_master_single_master" {
  name        = "acessos_master_single_master"
  description = "acessos_workers_single_master inbound traffic"
  vpc_id      = aws_vpc.vpc_uk.id  

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      cidr_blocks      = []
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = [
        "sg-088ebd8264b186ab8",
      ]
      self             = false
      to_port          = 0
    },
    {
      cidr_blocks      = [
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
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "acessos_master_single_master"
  }
}


resource "aws_security_group" "acessos_workers_single_master" {
  name        = "acessos_workers_single_master"
  description = "acessos_workers_single_master inbound traffic"
  vpc_id      = aws_vpc.vpc_uk.id
  
  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      cidr_blocks      = []
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = [
        "sg-0616d1b796a5ba05e",
      ]
      self             = false
      to_port          = 0
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "acessos_workers_single_master"
  }
}


# terraform refresh para mostrar o ssh
output "maquina_master" {
  value = [
    "master - ${aws_instance.maquina_master.public_ip} - ssh -i uk_key.pem ubuntu@${aws_instance.maquina_master.public_dns}"
  ]
}

# terraform refresh para mostrar o ssh
output "maquina_workers" {
  value = [
    for key, item in aws_instance.workers :
      "worker ${key+1} - ${item.public_ip} - ssh -i uk_key.pem ubuntu@${item.public_dns}"
  ]
}