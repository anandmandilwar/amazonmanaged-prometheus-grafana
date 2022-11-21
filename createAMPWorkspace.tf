resource "aws_prometheus_workspace" "ampworksapce" {
  alias = "${var.prometheus_workspace_name}"
  tags = {
    Environment = "Demo"
    Terraform = "true"
  }
}