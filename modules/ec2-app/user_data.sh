#!/bin/bash
sudo yum update -y
sudo yum install -y git curl

DB_HOST=$(aws ssm get-parameter --name "/symbiosis/db/host" --region ap-southeast-1 --query "Parameter.Value" --output text)
DB_USER=$(aws ssm get-parameter --name "/symbiosis/db/username" --region ap-southeast-1 --query "Parameter.Value" --output text)
DB_PASS=$(aws ssm get-parameter --name "/symbiosis/db/password" --with-decryption --region ap-southeast-1 --query "Parameter.Value" --output text)

echo "DB_HOST=$DB_HOST" >> /etc/environment
echo "DB_USER=$DB_USER" >> /etc/environment
echo "DB_PASS=$DB_PASS" >> /etc/environment

# Install Node.js via nvm
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
sudo yum install -y nodejs

# git clone and start the app
cd /home/ec2-user
sudo git clone https://github.com/Kumar-KSTMH/nodejs-mysql-crud.git /var/www/nodeapp
cd /var/www/nodeapp
sudo npm install
nohup node app.js > output.log 2>&1 &


