output "app_sg"{
    value= aws_security_group.app_sg.id
}
output "databases_sg"{
    value= aws_security_group.databases_sg.id
}