resource "consul_config_entry" "spring-echo-example" {
  name = "spring-echo-example"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "http"
  })
}
resource "consul_config_entry" "jaeger-query" {
  name = "jaeger-query"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "http"
  })
}
resource "consul_config_entry" "grafana-internal" {
  name = "grafana-internal"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "http"
  })
}
resource "consul_config_entry" "kibana" {
  name = "kibana"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "http"
  })
}

resource "consul_config_entry" "elastic-internal" {
  name = "elastic-internal"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "http"
  })
}

resource "consul_config_entry" "logstash-tcp-service-defaults" {
  name = "logstash-tcp"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "tcp"
  })
}

resource "consul_config_entry" "ingress_gateway" {
  name = "poc-ingress"
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
          Name = "elastic-internal"
          Hosts = [
            "elastic-internal.${var.external_domain}",
            "elastic-internal.${var.external_domain}:8080",
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
        }
      ]
    }]
  })
}