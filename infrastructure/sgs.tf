resource "aws_security_group" "security-group" {
  vpc_id = aws_vpc.vpc.id
  description = "Allowing SSH, Sonarqube, GitHub Actions access"

  ingress = [
      for port in [22, 8080, 9000, 9090, 80, 443] : {
      description      = "SSH from VPC"
      from_port        = port
      to_port          = port 
      protocol         = "tcp"
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = []
      security_groups  = []
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

        tags = {
    Name = var.sg_name
    Project = var.project_name
  }
}