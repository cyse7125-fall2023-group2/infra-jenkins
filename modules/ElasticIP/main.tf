resource "aws_eip" "jenkins_server_eip" {
  instance = var.jenkins_server_id
  domain   = "vpc"
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = var.jenkins_server_id
  allocation_id = aws_eip.jenkins_server_eip.id
}

resource "aws_route53_record" "a_record" {
  zone_id = var.zone_id
  name    = var.rec_name
  type    = "A"
  ttl     = 60
  records = [aws_eip_association.eip_assoc.public_ip]
}