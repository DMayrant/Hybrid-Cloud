resource "aws_launch_template" "ec2_launch_template" {
  name_prefix   = "ec2-launch-template-"
  image_id      = "ami-068c0051b15cdb816"
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  # Correct ASG pattern
  vpc_security_group_ids = [
    aws_security_group.app_sg.id
  ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "asg-nginx-instance"
    }
  }
}

