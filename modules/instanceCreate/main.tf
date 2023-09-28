resource "aws_instance" "jenkins_server" {
  # count = var.subnet_count

  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.ami_key_pair_name
  security_groups = ["${var.sec_id}"]
  #   iam_instance_profile    = var.ec2_profile_name
  disable_api_termination = true

  tags = {
    Name = "EC2-${var.ami_id}"
  }

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  subnet_id = var.subnet_ids[0]

  user_data = <<-EOF
              #!/bin/bash
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              sudo systemctl start caddy
              sudo caddy reverse-proxy --from :2080 --to :8080
              EOF
}

output "jenkins_server_id" {
  value = aws_instance.jenkins_server.id
}

