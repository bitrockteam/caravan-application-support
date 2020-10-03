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
            "jaeger.${var.subdomain}.${var.external_domain}",
            "jaeger.${var.subdomain}.${var.external_domain}:8080",
          ]
        },
        {
          Name = "grafana-internal"
          Hosts = [
            "grafana-internal.${var.subdomain}.${var.external_domain}",
            "grafana-internal.${var.subdomain}.${var.external_domain}:8080",
          ]
        },
        {
          Name = "kibana"
          Hosts = [
            "kibana.${var.subdomain}.${var.external_domain}",
            "kibana.${var.subdomain}.${var.external_domain}:8080",
          ]
        },
        {
          Name = "prometheus"
          Hosts = [
            "prometheus.${var.subdomain}.${var.external_domain}",
            "prometheus.${var.subdomain}.${var.external_domain}:8080",
          ]
        },
        {
          Name = "echo-server"
          Hosts = [
            "echo.${var.subdomain}.${var.external_domain}",
            "echo.${var.subdomain}.${var.external_domain}:8080",
          ]
        }
      ]
    }]
  })
}