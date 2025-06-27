output "app_sg"{
    value= aws_security_group.app_sg.id
}
output "redis_sg"{
    value   = aws_security_group.redis_sg.id
}
output "postgres_sg"{
    value   = aws_security_group.rds_sg.id
}