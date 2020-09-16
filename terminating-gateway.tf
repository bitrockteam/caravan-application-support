resource "consul_config_entry" "terminating_gateway" {
  name = "poc-terminating"
  kind = "terminating-gateway"

  config_json = jsonencode({
    Services = [
      {
        Name = "devops-proxy-http"
      },
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

resource "nomad_job" "poc-terminating" {
  jobspec = file("${path.module}/jobs/poc-terminating.hcl")
}

resource "consul_intention" "devops-proxy-http" {
  source_name      = "*"
  destination_name = "devops-proxy-http"
  action           = "allow"
}
