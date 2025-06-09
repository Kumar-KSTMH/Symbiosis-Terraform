#!/bin/bash
# Update and install prerequisites
sudo yum update -y
sudo yum install -y git 
sudo yum install -y curl

# Get DB credentials from SSM
DB_NAME=$(aws ssm get-parameter --name "/symbiosis/db/name" --region ap-southeast-1 --query "Parameter.Value" --output text)
DB_HOST=$(aws ssm get-parameter --name "/symbiosis/db/host" --region ap-southeast-1 --query "Parameter.Value" --output text)
DB_USER=$(aws ssm get-parameter --name "/symbiosis/db/username" --region ap-southeast-1 --query "Parameter.Value" --output text)
DB_PASS=$(aws ssm get-parameter --name "/symbiosis/db/password" --with-decryption --region ap-southeast-1 --query "Parameter.Value" --output text)

# Export DB variables system-wide
echo "DB_NAME=$DB_NAME" >> /etc/environment
echo "DB_HOST=$DB_HOST" >> /etc/environment
echo "DB_USER=$DB_USER" >> /etc/environment
echo "DB_PASS=$DB_PASS" >> /etc/environment

# Install Node.js
sudo curl -sL https://rpm.nodesource.com/setup_18.x | bash -
sudo yum install -y nodejs

# App setup as ec2-user
cd /home/ec2-user
git clone https://github.com/Kumar-KSTMH/nodejs-mysql-crud.git nodeapp
cd nodeapp

set -a
source /etc/environment
set +a
sudo npm install
sudo pm2 restart all
# Start the Node app
sudo chown ec2-user:ec2-user /home/ec2-user/app.log
echo "Starting app..." >> /home/ec2-user/app.log
cd /home/ec2-user/nodeapp
npm install express-validator@5.3.1
node app.js

nohup node app.js >> /home/ec2-user/app.log 2>&1 &

