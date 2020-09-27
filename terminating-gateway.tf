resource "consul_config_entry" "terminating_gateway" {
  name = "poc-terminating"
  kind = "terminating-gateway"

  config_json = jsonencode({
    Services = [
      {
        Name = "logstash-tcp"
      },
      {
        Name = "logstash-http"
      },
      {
        Name = "elastic-internal"
      },
      {
        Name = "grafana-internal"
      },
      {
        Name = "jaeger-query"
      }
    ]
  })
}
