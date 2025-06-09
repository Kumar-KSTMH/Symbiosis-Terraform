#!/bin/bash
sudo yum update -y
sudo yum install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx

cat > /etc/nginx/conf.d/nodeapp.conf <<EOF
server {
    listen 80;
    location / {
        proxy_pass http://${app_alb_dns}:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

sudo nginx -t && sudo systemctl reload nginx
sudo nginx -t && sudo systemctl restart nginx
