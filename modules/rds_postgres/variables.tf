variable "environment" {
  type        = string
  description = "Environment name (e.g. dev, test, prod)"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the RDS subnet group"
}

variable "postgres_sg_id" {
  type        = string
  description = "Security group ID that allows access to the RDS instance"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "Instance type for the RDS instance"
}

variable "engine_version" {
  type        = string
  default     = "17.4"
  description = "PostgreSQL engine version"
}

variable "allocated_storage" {
  type        = number
  default     = 20
  description = "Storage size in GB"
}

variable "username" {
  type        = string
  description = "Master username for PostgreSQL"
  default     = "postgres"
}

variable "password" {
  type        = string
  description = "Master password for PostgreSQL"
  default     = "postgres"
  sensitive   = true
}

variable "db_name" {
  type        = string
  default     = "votedb"
  description = "Initial database name"
}

variable "app_sg_id" {
  type        = string
  description = "Security group ID for the application that needs to access the RDS instance"
}