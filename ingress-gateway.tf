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
            "jaeger.${var.domain}",
            "jaeger.${var.domain}:8080",
          ]
        },
        {
          Name = "grafana-internal"
          Hosts = [
            "grafana-internal.${var.domain}",
            "grafana-internal.${var.domain}:8080",
          ]
        },
        {
          Name = "kibana"
          Hosts = [
            "kibana.${var.domain}",
            "kibana.${var.domain}:8080",
          ]
        },
        {
          Name = "keycloak"
          Hosts = [
            "keycloak.${var.domain}",
            "keycloak.${var.domain}:8080",
          ]
        },
        {
          Name = "jenkins"
          Hosts = [
            "jenkins.${var.domain}",
            "jenkins.${var.domain}:8080",
          ]
        },
        {
          Name = "prometheus"
          Hosts = [
            "prometheus.${var.domain}",
            "prometheus.${var.domain}:8080",
          ]
        },
        {
          Name = "echo-server"
          Hosts = [
            "echo.${var.domain}",
            "echo.${var.domain}:8080",
          ]
        },
        {
          Name = "opentraced-app-b"
          Hosts = [
            "opentraced-app-b.${var.domain}",
            "opentraced-app-b.${var.domain}:8080",
          ]
        },
      ]
    }]
  })
}