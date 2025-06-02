#!/bin/bash
yum update -y
amazon-linux-extras install -y nginx1
systemctl enable nginx
systemctl start nginx

cat > /etc/nginx/conf.d/nodeapp.conf <<EOF
server {
    listen 80;
    location / {
        proxy_pass http://${app_alb_dns};
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

systemctl restart nginx
