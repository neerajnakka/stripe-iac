resource "aws_instance" "strapi_app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.vpc.public_subnets[0]
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.strapi_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              # Update and install dependencies
              apt-get update
              apt-get install -y curl git build-essential

              # Install Node.js (LTS)
              curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
              apt-get install -y nodejs

              # Install PM2
              npm install -g pm2
              EOF

  tags = {
    Name = "${var.project_name}-app"
  }
}
