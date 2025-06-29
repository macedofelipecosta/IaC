resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-postgres-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.environment}-postgres-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier             = "${var.environment}-postgres"
  engine                 = "postgres"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = "gp2"
  username               = var.username
  password               = var.password
  db_name                = var.db_name
  port                   = 5432
  publicly_accessible    = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.postgres_sg_id, var.app_sg_id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  tags = {
    Name        = "${var.environment}-postgres"
    Environment = var.environment
    Project     = "voting-app"
  }
}
