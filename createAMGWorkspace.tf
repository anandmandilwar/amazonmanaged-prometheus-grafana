#====================================
# Amazon Managed Grafana - Workspace 
#====================================
resource "aws_grafana_workspace" "Grafana_workspace" {
  description = uuid()
  lifecycle {
    ignore_changes = [description]
  }
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

#======================================
# Amazon Managed Grafana - Serviec Role 
#======================================
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

#===================================================
#Grafana Role Policy - AmazonGrafanaCloudWatchPolicy
#===================================================
resource "aws_iam_role_policy" "grafana_AmazonGrafanaCloudWatchPolicy" {
  name = "AmazonGrafana_CloudWatch_policy"
  role = aws_iam_role.assume.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowReadingMetricsFromCloudWatch",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:DescribeAlarmsForMetric",
                "cloudwatch:DescribeAlarmHistory",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:GetMetricData",
                "cloudwatch:GetInsightRuleReport"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowReadingLogsFromCloudWatch",
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogGroups",
                "logs:GetLogGroupFields",
                "logs:StartQuery",
                "logs:StopQuery",
                "logs:GetQueryResults",
                "logs:GetLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowReadingTagsInstancesRegionsFromEC2",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeTags",
                "ec2:DescribeInstances",
                "ec2:DescribeRegions"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowReadingResourcesForTags",
            "Effect": "Allow",
            "Action": "tag:GetResources",
            "Resource": "*"
        }
    ]
}
EOF
}

#===================================================
#Grafana Role Policy - AmazonGrafanaPrometheusPolicy
#===================================================
resource "aws_iam_role_policy" "grafana_AmazonGrafanaPrometheusPolicy" {
  name = "AmazonGrafana_Prometheus_policy"
  role = aws_iam_role.assume.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "aps:ListWorkspaces",
                "aps:DescribeWorkspace",
                "aps:QueryMetrics",
                "aps:GetLabels",
                "aps:GetSeries",
                "aps:GetMetricMetadata"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

#=============================================
#Grafana Role Policy - AmazonGrafanaSNSPolicy
#=============================================
resource "aws_iam_role_policy" "grafana_AmazonGrafanaSNSPolicy" {
  name = "AmazonGrafana_SNS_policy"
  role = aws_iam_role.assume.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": [
                "arn:aws:sns:*:${var.aws_account_ID}:grafana*"
            ]
        }
    ]
}
EOF
}


#========================================================
# Role Association for Amazon Managed Grafana - Workspace 
#========================================================
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_role_association
resource "aws_grafana_role_association" "role" {
  role         = "ADMIN"
  user_ids =   [var.User_ID]
  workspace_id = aws_grafana_workspace.Grafana_workspace.id
}

resource "aws_grafana_workspace_api_key" "keyViewer" {
  key_name        = "test-key-VIEWER"
  key_role        = "VIEWER"
  seconds_to_live = 3600
  workspace_id    = aws_grafana_workspace.Grafana_workspace.id
}

resource "aws_grafana_workspace_api_key" "keyEditor" {
  key_name        = "test-key-Editor"
  key_role        = "EDITOR"
  seconds_to_live = 3600
  workspace_id    = aws_grafana_workspace.Grafana_workspace.id
}

resource "aws_grafana_workspace_api_key" "keyAdmin" {
  key_name        = "test-key-Admin"
  key_role        = "ADMIN"
  seconds_to_live = 3600
  workspace_id    = aws_grafana_workspace.Grafana_workspace.id
}
