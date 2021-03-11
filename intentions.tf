resource "consul_config_entry" "star" {
  name = "*"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "consul-esm"
      Precedence = 6
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "jaeger_agent" {
  name = "jaeger-agent"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "*"
      Precedence = 8
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "jaeger_collector" {
  name = "jaeger-collector"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "*"
      Precedence = 8
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "jaeger_query" {
  name = "jaeger-query"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "ingress-gateway"
      Precedence = 9
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "kibana" {
  name = "kibana"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "ingress-gateway"
      Precedence = 9
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "grafana_internal" {
  name = "grafana-internal"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "ingress-gateway"
      Precedence = 9
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "prometheus" {
  name = "prometheus"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "ingress-gateway"
      Precedence = 9
      Type       = "consul"
      }
    ]
  })
}

resource "consul_config_entry" "elastic_internal" {
  name = "elastic-internal"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "jaeger-collector"
      Precedence = 9
      Type       = "consul"
      }, {
      Action     = "allow"
      Name       = "jaeger-query"
      Precedence = 9
      Type       = "consul"
      }, {
      Action     = "allow"
      Name       = "kibana"
      Precedence = 9
      Type       = "consul"
      }, {
      Action     = "allow"
      Name       = "ingress-gateway"
      Precedence = 9
      Type       = "consul"
    }]
  })
}


