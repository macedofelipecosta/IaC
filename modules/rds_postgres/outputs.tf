output "postgres_endpoint" {
  value       = aws_db_instance.this.address
  description = "Endpoint of the PostgreSQL RDS instance"
}

output "postgres_port" {
  value       = aws_db_instance.this.port
  description = "PostgreSQL port (default 5432)"
}

output "postgres_db_name" {
  value       = aws_db_instance.this.db_name
  description = "Database name"
}

output "postgres_instance_id"{
  value       = aws_db_instance.this.id
  description = "ID of the PostgreSQL RDS instance"

}

output "postgres_instance_arn" {
  value       = aws_db_instance.this.arn
  description = "ARN of the PostgreSQL RDS instance"
}

