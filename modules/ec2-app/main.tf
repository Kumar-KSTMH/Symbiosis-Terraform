resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-lt-"
  image_id      = var.ami_id # Amazon Linux 2
  instance_type = "t2.micro"
  key_name      = var.key_name

  block_device_mappings {
    device_name = "/dev/xvda"
  
  ebs {
    volume_size           = 20
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }
  }
  
  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  network_interfaces {
    subnet_id                   = var.app_subnet_1a_id
    security_groups             = [var.app_sg]
    associate_public_ip_address = false
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "app-instance"
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y

    # Install Node.js
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install 16
    nvm use 16

    # Setup Node.js app (you can replace this with a real app)
    mkdir -p /var/www/nodeapp
    echo "const http = require('http'); const server = http.createServer((req, res) => res.end('Hello from App Tier')); server.listen(3000);" > /var/www/nodeapp/app.js
    nohup node /var/www/nodeapp/app.js > /var/www/nodeapp/output.log 2>&1 &
  EOF
  )
}
