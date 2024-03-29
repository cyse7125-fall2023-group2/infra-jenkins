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
              wget https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.12.13/jenkins-plugin-manager-2.12.13.jar 
              java -jar jenkins-plugin-manager-2.12.13.jar --plugin-file=/usr/share/jenkins/plugins.txt --war=/usr/share/java/jenkins.war
              sudo cp -fR /usr/share/jenkins/ref/plugins/  /var/lib/jenkins/
              chmod 666 /var/run/docker.sock
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              sudo systemctl stop jenkins
              sudo systemctl daemon-reload
              sudo systemctl start jenkins
              sudo mv /etc/caddy/Caddyfile /opt/
              sudo touch /etc/caddy/Caddyfile
              sudo chown -R root:ubuntu /etc/caddy/Caddyfile 
              sudo chmod -R 664 /etc/caddy/Caddyfile 
              sudo echo ${var.rec_name} { >> /etc/caddy/Caddyfile
              sudo echo reverse_proxy localhost:8080 >> /etc/caddy/Caddyfile
              sudo echo } >> /etc/caddy/Caddyfile
              caddy fmt --overwrite /etc/caddy/Caddyfile 
              sudo apt install make
              curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
              echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
              sudo apt-get update && sudo apt-get install google-cloud-cli
              sudo apt install golang-go
              sudo apt install kubectl
              sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
              curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
              chmod 700 get_helm.sh
              ./get_helm.sh
              sudo systemctl stop caddy
              sudo systemctl start caddy
              EOF
}

data "aws_eip" "jenkins_eip" {
  filter {
    name   = "tag:name"
    values = ["jenkins"]
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.jenkins_server.id
  allocation_id = data.aws_eip.jenkins_eip.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "a_record" {
  zone_id = var.zone_id
  name    = var.rec_name
  type    = "A"
  ttl     = 60
  records = [aws_eip_association.eip_assoc.public_ip]
}


