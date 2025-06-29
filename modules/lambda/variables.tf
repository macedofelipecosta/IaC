variable "environment" {
  description = "Environment name (e.g. dev, test, prod)"
  type        = string
}

variable "lambda_zip_file" {
  description = "Path to the Lambda zip file"
  type        = string
}
variable "role_arn" {
  description = "ARN of the IAM role for the Lambda function"
  type        = string
}
