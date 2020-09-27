resource "consul_config_entry" "ingress_gateway" {
  name = "ingress-gateway"
  kind = "ingress-gateway"

  config_json = jsonencode({
    Listeners = [{
      Port     = 8080
      Protocol = "http"
      Services = [
        {
          Name = "jaeger-query"
          Hosts = [
            "jaeger.${var.external_domain}",
            "jaeger.${var.external_domain}:8080",
          ]
        },
        {
          Name = "grafana-internal"
          Hosts = [
            "grafana-internal.${var.external_domain}",
            "grafana-internal.${var.external_domain}:8080",
          ]
        },
        {
          Name = "kibana"
          Hosts = [
            "kibana.${var.external_domain}",
            "kibana.${var.external_domain}:8080",
          ]
        },
        {
          Name = "prometheus"
          Hosts = [
            "prometheus.${var.external_domain}",
            "prometheus.${var.external_domain}:8080",
          ]
        },
        {
          Name = "echo-server"
          Hosts = [
            "echo.${var.external_domain}",
            "echo.${var.external_domain}:8080",
          ]
        }
      ]
    }]
  })
}