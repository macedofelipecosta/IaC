variable "vpc_id" {
  description = "VPC ID for the Cloud Map namespace"
  type        = string
}

variable "namespace_name" {
  description = "Name of the private DNS namespace"
  type        = string
  default     = "voting.local"
}

variable "environment" {
  description = "Environment tag"
  type        = string
}
