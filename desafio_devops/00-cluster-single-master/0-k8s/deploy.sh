#!/bin/bash

cd 0-terraform
terraform init
terraform apply -auto-approve

echo "Aguardando criação de maquinas ..."
sleep 1 # 10 segundos

echo $"[ec2-master]" > ../1-ansible/hosts # cria arquivo
echo "$(terraform output | grep master_node | awk '{print $3}')" | sed -e "s/\",//g" >> ../1-ansible/hosts # captura output faz split de espaco e replace de ",
echo "[ec2-master:vars]" >> ../1-ansible/hosts
echo "ansible_python_interpreter=/usr/bin/python3" >> ../1-ansible/hosts
echo $"[ec2-worker1]" >> ../1-ansible/hosts # cria arquivo
echo "$(terraform output | grep worker1 | awk '{print $3}')" | sed -e "s/\",//g" >> ../1-ansible/hosts # captura output faz split de espaco e replace de ",
echo "[ec2-worker1:vars]" >> ../1-ansible/hosts
echo "ansible_python_interpreter=/usr/bin/python3" >> ../1-ansible/hosts
echo $"[ec2-worker2]" >> ../1-ansible/hosts # cria arquivo
echo "$(terraform output | grep worker2 | awk '{print $3}')" | sed -e "s/\",//g" >> ../1-ansible/hosts # captura output faz split de espaco e replace de ",
echo "[ec2-worker2:vars]" >> ../1-ansible/hosts
echo "ansible_python_interpreter=/usr/bin/python3" >> ../1-ansible/hosts
echo $"[ec2-worker3]" >> ../1-ansible/hosts # cria arquivo
echo "$(terraform output | grep worker3 | awk '{print $3}')" | sed -e "s/\",//g" >> ../1-ansible/hosts # captura output faz split de espaco e replace de ",
echo "[ec2-worker3:vars]" >> ../1-ansible/hosts
echo "ansible_python_interpreter=/usr/bin/python3" >> ../1-ansible/hosts

MASTER=$(terraform output | grep security_group_master | awk '{print $3}' | sed 's/"//g')
WORKER=$(terraform output | grep security_group_workers | awk '{print $3}' | sed 's/"//g')

echo "Ajustando security group ..."
cd security_group
terraform apply -var="sg-master=${MASTER}" -var="sg-worker=${WORKER}" -auto-approve



sleep 1 # 10 segundos

cd ../../1-ansible

echo "Executando ansible ::::: [ ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key ~/.ssh/privatekey_mysql_uk.pem --ssh-common-args='-o StrictHostKeyChecking=no']"
#ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key ~/.ssh/privatekey_mysql_uk.pem --ssh-common-args='-o StrictHostKeyChecking=no'