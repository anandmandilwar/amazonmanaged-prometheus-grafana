resource "aws_grafana_workspace" "workspace" {
  name                     = "${var.grafana_workspace_name}"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "SERVICE_MANAGED"
  role_arn                 = aws_iam_role.assume.arn
  data_sources             = ["CLOUDWATCH","PROMETHEUS"]
  tags  = {
    Terraform = "true"
    Environment = "Demo"
  }
}

resource "aws_iam_role" "assume" {
  name = "tf-grafana-assume"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "grafana.amazonaws.com"
        }
      },
    ]
  })
}
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_role_association
resource "aws_grafana_role_association" "role" {
  role         = "ADMIN"
  user_ids =   [var.User_ID]
  workspace_id = aws_grafana_workspace.workspace.id
}

resource "aws_grafana_workspace_api_key" "keyViewer" {
  key_name        = "test-key-VIEWER"
  key_role        = "VIEWER"
  seconds_to_live = 3600
  workspace_id    = aws_grafana_workspace.workspace.id
}

resource "aws_grafana_workspace_api_key" "keyEditor" {
  key_name        = "test-key-Editor"
  key_role        = "EDITOR"
  seconds_to_live = 3600
  workspace_id    = aws_grafana_workspace.workspace.id
}

resource "aws_grafana_workspace_api_key" "keyAdmin" {
  key_name        = "test-key-Admin"
  key_role        = "ADMIN"
  seconds_to_live = 3600
  workspace_id    = aws_grafana_workspace.workspace.id
}