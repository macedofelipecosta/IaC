resource "aws_db_instance" "persistant_database" {
  allocated_storage       = 20
  backup_retention_period = 1
  engine                  = "postgres"
  engine_version          = "9.6.22"
  identifier              = "postgres-db-${var.environment}"
  instance_class          = "db.t3.small"
  multi_az                = false
  db_name                 = "postgres"
  password                = "password"
  port                    = 5432
  publicly_accessible     = true
  storage_encrypted       = true
  storage_type            = "gp2"
  username                = "votingapp_admin"
  vpc_security_group_ids  = [var.databases_sg]
  db_subnet_group_name    = aws_db_subnet_group.subnet_db.name
  skip_final_snapshot     = true
}

resource "aws_db_subnet_group" "subnet_db" {
  name = "db_subnet_group-${var.environment}"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name        = "db_subnet_group-${var.environment}"
    environment = var.environment
  }
}