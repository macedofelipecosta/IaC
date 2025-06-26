
variable "environment" {}
variable "cluster_arn" {}
variable "subnet_ids" { type = list(string) }
variable "security_group_id" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}
variable "postgres_image" {}
variable "db_service_arn" {}
