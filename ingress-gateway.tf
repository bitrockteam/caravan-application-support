resource "consul_config_entry" "spring-echo-example" {
  name = "spring-echo-example"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "http"
  })
}
resource "consul_config_entry" "microservizio" {
  name = "microservizio"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "http"
  })
}
resource "consul_config_entry" "jaeger" {
  name = "jaeger"
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
            "spring-echo-example",
            "spring-echo-example:8080",
          ]
        },
        {
          Name = "microservizio"
          Hosts = [
            "microservizio",
            "microservizio:8080",
          ]
        },
        {
          Name = "jaeger-query"
          Hosts = [
            "jaeger",
            "jaeger:8080",
          ]
        },
        {
          Name = "elastic-internal"
          Hosts = [
            "elastic-internal",
            "elastic-internal:8080",
          ]
        },
        {
          Name = "grafana-internal"
          Hosts = [
            "grafana-internal",
            "grafana-internal:8080",
          ]
        }
      ]
    }]
  })
}

resource "nomad_job" "poc-ingress" {
  jobspec = file("${path.module}/jobs/poc-ingress.hcl")
}

resource "consul_intention" "echo_service" {
  source_name      = "poc-ingress"
  destination_name = "spring-echo-example"
  action           = "allow"
}
resource "consul_intention" "microservizio_service" {
  source_name      = "poc-ingress"
  destination_name = "microservizio"
  action           = "allow"
}
