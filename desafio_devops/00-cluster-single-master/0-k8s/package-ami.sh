#!/bin/bash

VERSAO=$(git describe --tags $(git rev-list --tags --max-count=1))

cd 0-terraform
RESOURCE_ID=$(terraform output | grep resource_id | awk '{print $4;exit}' | sed 's/"//g')

cd terraform-ami
terraform init
terraform apply -var="versao=${VERSAO}" -var="resource_id=${RESOURCE_ID}" -auto-approve