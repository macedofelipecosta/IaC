locals {
  app_ports = [5000, 5001, 5858, 80]
  db_ports  = [6379, 5432]
}

resource "aws_security_group" "app_sg" {
  name        = "${var.environment}-app_sg"
  description = "Se implementa un sg para las app vote y result para los puertos 5000, 5001, 5858, 80 "
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.app_ports
    content {
      description      = "Se implementa un sg para las app vote y result para los puertos 5000, 5001, 5858, 80 "
      from_port        = ingress.value
      to_port          = element(local.app_ports, index(local.app_ports, ingress.value))
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.environment}-app_sg"
    environment = var.environment
  }
}

resource "aws_security_group" "databases_sg" {
  name        = "${var.environment}-db_sg"
  description = "Se utiliza un sg para ambas db con los puertos 6379 y 5432"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.db_ports
    content {
      description     = "Se utiliza un sg para ambas db con los puertos 6379 y 5432"
      from_port       = ingress.value
      to_port         = element(local.db_ports, index(local.db_ports, ingress.value))
      protocol        = "tcp"
      security_groups = [aws_security_group.app_sg.id]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name= "${var.environment}-app_sg"
    environment = var.environment
  }
}
