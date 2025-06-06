resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt-"
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

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    app_alb_dns = var.app_alb_dns_name
  }))

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }



  network_interfaces {
    subnet_id                   = var.web_subnet_1a_id
    security_groups             = [var.web_sg]
    associate_public_ip_address = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-instance"
    }
  }
}