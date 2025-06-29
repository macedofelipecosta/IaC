variable "environment" {
  type        = string
  description = "Environment name (e.g. dev, test, prod)"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the ElastiCache subnet group"
}

variable "redis_sg_id" {
  type        = string
  description = "Security Group ID for Redis access"
}

variable "node_type" {
  type        = string
  default     = "cache.t3.micro"
  description = "Instance type for Redis nodes"
}

variable "engine_version" {
  type        = string
  default     = "7.0"
  description = "Redis engine version"
}
variable "app_sg_id" {
  type        = string
  description = "Security Group ID for the application that needs to access the Redis instance"
}