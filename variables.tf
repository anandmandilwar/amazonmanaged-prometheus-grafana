#Define AWS Region
variable "region" {
  description = "Infrastructure region"
  type        = string
  default     = "us-east-1"
}
#Define IAM User Access Key
variable "access_key" {
  description = "The access_key that belongs to the IAM user"
  type        = string
  sensitive   = true
}
#Define IAM User Secret Key
variable "secret_key" {
  description = "The secret_key that belongs to the IAM user"
  type        = string
  sensitive   = true
}

#Define IAM User ID created in IAM Identity Center as Pre-requisite
variable "User_ID" {
  description = "The User ID of the user created in IAM Identity Center"
  type        = string
  sensitive   = true
}

#Define Grafana workspace Name
variable "grafana_workspace_name" {
  description = "name of Amazon Managed Grafana workspace"
  type        = string
  default = "managedGrafanaDemo"
}

#Define AMP workspace Name
variable "prometheus_workspace_name" {
  description = "name of Amazon Managed Prometheus workspace"
  type        = string
  default = "managedPrometheusDemo"
}

#AWS Account ID that hosts Managed Grafana workspace
variable "aws_account_ID" {
  description = "Account ID of the Grafana workspace"
  type = string
}

