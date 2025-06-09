resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-lt-"
  image_id      = var.ami_id
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

  user_data = filebase64("../modules/ec2-app/config_data.sh")

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

}