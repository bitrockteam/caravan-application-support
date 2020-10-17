locals {
  dashboards = { for f in fileset(path.module, "grafana_dashboards/*.json") : basename(trimsuffix(f, ".json")) => f }
}

resource "grafana_dashboard" "dashboard" {
  for_each    = local.dashboards
  config_json = file(each.value)
}

resource "grafana_data_source" "metrics" {
  type       = "prometheus"
  name       = "Prometheus"
  url        = "http://localhost:9090"
  is_default = true
}