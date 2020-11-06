resource "consul_config_entry" "terminating_gateway" {
  name = "terminating-gateway"
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
        Name = "jaeger-query"
      },
      {
        Name = "grafana-internal"
      },
      {
        Name = "elastic-internal"
      },
      {
        Name = "prometheus"
      },
      {
        Name = "jenkins"
      }
    ]
  })
}
