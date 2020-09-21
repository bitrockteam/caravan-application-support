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

resource "consul_config_entry" "elastic-internal" {
  name = "elastic-internal"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "http"
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
          Name = "spring-echo-example"
          Hosts = [
            "echo.hcpoc.bitrock.it",
            "echo.hcpoc.bitrock.it:8080",
          ]
        },
        {
          Name = "jaeger-query"
          Hosts = [
            "jaeger.hcpoc.bitrock.it",
            "jaeger.hcpoc.bitrock.it:8080",
          ]
        },
        {
          Name = "elastic-internal"
          Hosts = [
            "elastic-internal.hcpoc.bitrock.it",
            "elastic-internal.hcpoc.bitrock.it:8080",
          ]
        },
        {
          Name = "grafana-internal"
          Hosts = [
            "grafana-internal.hcpoc.bitrock.it",
            "grafana-internal.hcpoc.bitrock.it:8080",
          ]
        }
      ]
    }]
  })
}

resource "nomad_job" "poc-ingress" {
  jobspec = file("${path.module}/jobs/poc-ingress.hcl")
}