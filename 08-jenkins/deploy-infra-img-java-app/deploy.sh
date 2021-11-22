#!/bin/bash

cd 08-jenkins/deploy-infra-img-java-app/terraform
terraform init
terraform apply -auto-approve

echo "Aguardando criação de maquinas ..."
sleep 10 # 10 segundos

echo $"[ec2-dev-img-jenkins]" > ../ansible/hosts # cria arquivo
echo "$(/home/ubuntu/terraform output | grep public_dns | awk '{print $2;exit}')" | sed -e "s/\",//g" >> ../ansible/hosts # captura output faz split de espaco e replace de ",
echo "[ec2-jenkins:vars]" >> ../1-ansible/hosts
echo "ansible_python_interpreter=/usr/bin/python3" >> ../1-ansible/hosts

echo "Aguardando criação de maquinas ..."

sleep 10 # 10 segundos

cd ../ansible

echo "Executando ansible ::::: [ ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/privatekey_mysql_uk.pem --ssh-common-args='-o StrictHostKeyChecking=no']"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/privatekey_mysql_uk.pem --ssh-common-args='-o StrictHostKeyChecking=no'