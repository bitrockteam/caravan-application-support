resource "consul_config_entry" "star" {
  name = "*"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "consul-esm"
      Precedence = 9
      Type       = "consul"
      }, {
      Action     = "allow"
      Name       = "faasd-nats"
      Precedence = 9
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
      Precedence = 9
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
      Precedence = 9
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

resource "consul_config_entry" "keycloak" {
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

resource "consul_config_entry" "waypoint_server" {
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
      }, {
      Action     = "allow"
      Name       = "faasd-gateway"
      Precedence = 9
      Type       = "consul"
    }]
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

resource "consul_config_entry" "opentraced_app" {
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

resource "consul_config_entry" "opentraced_app_b" {
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

resource "consul_config_entry" "jenkins" {
  name = "jenkins"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "ingress-gateway"
      Precedence = 9
      Type       = "consul"
      }, {
      Action     = "allow"
      Name       = "jenkins"
      Precedence = 9
      Type       = "consul"
      },
      {
        Action     = "allow"
        Name       = "nomad"
        Precedence = 9
        Type       = "consul"
    }]
  })
}

resource "consul_config_entry" "faasd_nats" {
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
