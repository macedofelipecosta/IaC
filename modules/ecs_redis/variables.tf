
variable "environment" {}
variable "cluster_arn" {}
variable "subnet_ids" { type = list(string) }
variable "security_group_id" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}
variable "redis_image" {}
variable "redis_service_arn" {}

