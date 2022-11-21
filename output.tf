################################################################################
# Workspace
################################################################################

output "workspace_arn" {
  description = "Amazon Resource Name (ARN) of the workspace"
  value       = aws_prometheus_workspace.ampworksapce.arn
}

output "workspace_id" {
  description = "Identifier of the workspace"
  value       = aws_prometheus_workspace.ampworksapce.id
}

output "workspace_prometheus_endpoint" {
  description = "Prometheus endpoint available for this workspace"
  value       = aws_prometheus_workspace.ampworksapce.prometheus_endpoint
}

output "aws_grafana_workspace_value" {
  value = aws_grafana_workspace.workspace.id
  sensitive = true
}

