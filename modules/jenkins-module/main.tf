resource "tls_private_key" "linux-keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "linux-pem-key" {
  content         = tls_private_key.linux-keypair.private_key_pem
  filename        = "${var.linux-keypair}-keypair.pem"
  file_permission = "0400"
}

resource "aws_key_pair" "key-pair" {
  key_name   = "${var.linux-keypair}-keypair"
  public_key = tls_private_key.linux-keypair.public_key_openssh
}

resource "aws_instance" "jenkins" {
  ami                         = var.ami_id_ubuntu
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key-pair.key_name
  vpc_security_group_ids      = [var.security_group_id]
  subnet_id                   = var.public_subnet_id

  user_data = file("${path.module}/app-scripts/install.sh")

  tags = {
    Name = "${var.name}-server"
  }

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  depends_on = [local_file.linux-pem-key]
}

