#!/bin/bash

yum install ansible python3.11-pip.noarch -y | tee -a /opt/userdata.log
pip3.11 install botocore  boto3 | tee -a /opt/userdata.log
ansible-pull -i localhost, -U https://github.com/awsdevops99/expense-ansible.git -e role_name = ${role_name} -e env=dev | tee -a /opt/userdata.log