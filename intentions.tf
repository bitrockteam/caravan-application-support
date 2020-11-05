resource "consul_intention" "esm" {
  source_name      = "consul-esm"
  destination_name = "*"
  action           = "allow"
}

resource "consul_intention" "jaeger-agent" {
  source_name      = "*"
  destination_name = "jaeger-agent"
  action           = "allow"
}

resource "consul_intention" "jaeger-collector" {
  source_name      = "*"
  destination_name = "jaeger-collector"
  action           = "allow"
}

resource "consul_intention" "ingress_jaeger-query" {
  source_name      = "ingress-gateway"
  destination_name = "jaeger-query"
  action           = "allow"
}

resource "consul_intention" "ingress_kibana" {
  source_name      = "ingress-gateway"
  destination_name = "kibana"
  action           = "allow"
}

resource "consul_intention" "ingress_keycloak" {
  source_name      = "ingress-gateway"
  destination_name = "keycloak"
  action           = "allow"
}

resource "consul_intention" "ingress_waypoint" {
  source_name      = "ingress-gateway"
  destination_name = "waypoint-server"
  action           = "allow"
}

resource "consul_intention" "ingress_grafana" {
  source_name      = "ingress-gateway"
  destination_name = "grafana-internal"
  action           = "allow"
}

resource "consul_intention" "ingress_prometheus" {
  source_name      = "ingress-gateway"
  destination_name = "prometheus"
  action           = "allow"
}

resource "consul_intention" "ingress_echo-server" {
  source_name      = "ingress-gateway"
  destination_name = "echo-server"
  action           = "allow"
}

resource "consul_intention" "jaeger-query_jaeger-collector" {
  source_name      = "jaeger-query"
  destination_name = "jaeger-collector"
  action           = "allow"
}

resource "consul_intention" "jaeger-collector_elastic-internal" {
  source_name      = "jaeger-collector"
  destination_name = "elastic-internal"
  action           = "allow"
}

resource "consul_intention" "jaeger-query_elastic-internal" {
  source_name      = "jaeger-query"
  destination_name = "elastic-internal"
  action           = "allow"
}

resource "consul_intention" "kibana_elastic-internal" {
  source_name      = "kibana"
  destination_name = "elastic-internal"
  action           = "allow"
}

resource "consul_intention" "echo-server_kibana" {
  source_name      = "echo-server"
  destination_name = "kibana"
  action           = "allow"
}

resource "consul_intention" "opentraced-app-b_pentraced-app" {
  source_name      = "opentraced-app-b"
  destination_name = "opentraced-app"
  action           = "allow"
}

resource "consul_intention" "echo-server_opentraced-app" {
  source_name      = "echo-server"
  destination_name = "opentraced-app"
  action           = "allow"
}

resource "consul_intention" "ingress_opentraced-app-b" {
  source_name      = "ingress-gateway"
  destination_name = "opentraced-app-b"
  action           = "allow"
}

resource "consul_intention" "ingress_jenkins" {
  source_name      = "ingress-gateway"
  destination_name = "jenkins"
  action           = "allow"
}

resource "consul_intention" "jenkins_nomad" {
  source_name      = "jenkins"
  destination_name = "nomad"
  action           = "allow"
}

resource "consul_intention" "nomad_jenkins" {
  source_name      = "nomad"
  destination_name = "jenkins"
  action           = "allow"
}
