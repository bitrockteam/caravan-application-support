resource "consul_config_entry" "esm" {
  name = "*"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "consul-esm"
      Precedence = 9
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "jaeger-agent" {
  name = "jaeger-agent"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "*"
      Precedence = 9
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "jaeger-collector" {
  name = "jaeger-collector"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "*"
      Precedence = 9
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "ingress_jaeger-query" {
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

resource "consul_config_entry" "ingress_kibana" {
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

resource "consul_config_entry" "ingress_keycloak" {
  name = "keycloak"
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

resource "consul_config_entry" "ingress_waypoint" {
  name = "waypoint-server"
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

resource "consul_config_entry" "ingress_grafana" {
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

resource "consul_config_entry" "ingress_prometheus" {
  name = "prometheus"
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

resource "consul_config_entry" "jaeger-query_jaeger-collector" {
  name = "jaeger-collector"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "jaeger-query"
      Precedence = 9
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "jaeger-collector_elastic-internal" {
  name = "elastic-internal"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "jaeger-collector"
      Precedence = 9
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "jaeger-query_elastic-internal" {
  name = "elastic-internal"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "jaeger-query"
      Precedence = 9
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "kibana_elastic-internal" {
  name = "elastic-internal"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "kibana"
      Precedence = 9
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "opentraced-app-b_pentraced-app" {
  name = "opentraced-app"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "opentraced-app-b"
      Precedence = 9
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "ingress_opentraced-app-b" {
  name = "opentraced-app-b"
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

resource "consul_config_entry" "ingress_jenkins" {
  name = "jenkins"
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

resource "consul_config_entry" "jenkins_nomad" {
  name = "nomad"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "jenkins"
      Precedence = 9
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "nomad_jenkins" {
  name = "jenkins"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "nomad"
      Precedence = 9
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "jenkins_jenkins" {
  name = "jenkins"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "*"
      Precedence = 9
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "gateway_nats" {
  name = "faasd-nats"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "faasd-gateway"
      Precedence = 9
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "faasd_provider" {
  name = "*"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "faasd-nats"
      Precedence = 9
      Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "faasd_gateway" {
  name = "faasd-gateway"
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

resource "consul_config_entry" "faasd_gateway_prom" {
  name = "prometheus"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "faasd-gateway"
      Precedence = 9
      Type       = "consul"
    }]
  })
}

