#!/bin/bash

cd desafio_devops
#terraform init
#terraform import aws_vpc.vpc_desafio vpc-0b7bc0aae8788da62
#terraform import aws_internet_gateway.igw_desafio igw-00383a5bb2468a105
terraform destroy -auto-approve

echo "Rede destruida ..."
#sleep 10 # 10 segundos

# echo $"[ec2-image]" > ../ansible/hosts # cria arquivo
# echo "$(terraform output | grep public_dns | awk '{print $2;exit}')" | sed -e "s/\",//g" > hosts # captura output faz split de espaco e replace de ",
# echo "[ec2-image:vars]" >> hosts
# echo "ansible_python_interpreter=/usr/bin/python3" >> hosts

# echo "Aguardando criação de maquinas ..."

# sleep 10 # 10 segundos

# echo "Executando ansible ::::: [ ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/privatekey_mysql_uk.pem --ssh-common-args='-o StrictHostKeyChecking=no']"
# ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/privatekey_mysql_uk.pem --ssh-common-args='-o StrictHostKeyChecking=no'