output "url_postgres" {
  value = aws_db_instance.persistant_database.endpoint
}
output "username_postgres" {
  value = aws_db_instance.persistant_database.username
}
output "password_postgres" {
  value = aws_db_instance.persistant_database.password
}
output "subnet_db_group_name" {
  value = aws_db_subnet_group.subnet_db.name
}