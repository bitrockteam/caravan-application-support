locals {
  dashboards = var.configure_grafana ? {
    for f in fileset(path.module, "grafana_dashboards/*.json") : basename(trimsuffix(f, ".json")) => f
  } : {}
}

resource "grafana_dashboard" "dashboard" {
  depends_on = [ nomad_job.consul-ingress ]
  for_each    = local.dashboards
  config_json = file(each.value)
}

resource "grafana_data_source" "metrics" {
  depends_on = [ nomad_job.consul-ingress ]
  count      = var.configure_grafana ? 1 : 0
  type       = "prometheus"
  name       = "Prometheus"
  url        = "http://localhost:9090"
  is_default = true
}
