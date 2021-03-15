locals {
  dashboards = var.configure_grafana ? {
    for f in fileset(path.module, "grafana_dashboards/*.json") : basename(trimsuffix(f, ".json")) => f
  } : {}
}

resource "null_resource" "grafana_healthy" {
  count      = var.configure_grafana ? 1 : 0
  provisioner "local-exec" {
    command = "while [ $(curl -k --silent --output /dev/null --write-out '%%{http_code}' https://grafana.${var.domain}/api/health) != \"200\" ]; do echo \"Waiting grafana reachable...\"; sleep 5; done"
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "grafana_dashboard" "dashboard" {
  depends_on  = [grafana_data_source.metrics]
  for_each    = local.dashboards
  config_json = file(each.value)
}

resource "grafana_data_source" "metrics" {
  depends_on = [null_resource.grafana_healthy, consul_config_entry.grafana_internal]
  count      = var.configure_grafana ? 1 : 0
  type       = "prometheus"
  name       = "Prometheus"
  url        = "http://localhost:9090"
  is_default = true
}
