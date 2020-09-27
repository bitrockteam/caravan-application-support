resource "consul_intention" "consul_to_all" {
  source_name      = "consul"
  destination_name = "*"
  action           = "allow"
}
resource "consul_intention" "all_to_consul" {
  source_name      = "*"
  destination_name = "consul"
  action           = "allow"
}

resource "consul_intention" "esm" {
  source_name      = "poc-esm"
  destination_name = "*"
  action           = "allow"
}

resource "consul_intention" "logstash-tcp" {
  source_name      = "*"
  destination_name = "logstash-tcp"
  action           = "allow"
}

resource "consul_intention" "logstash-http" {
  source_name      = "*"
  destination_name = "logstash-http"
  action           = "allow"
}

resource "consul_intention" "jaeger-agent" {
  source_name      = "*"
  destination_name = "jaeger-agent"
  action           = "allow"
}

resource "consul_intention" "ingress_jaeger-query" {
  source_name      = "poc-ingress"
  destination_name = "jaeger-query"
  action           = "allow"
}

resource "consul_intention" "ingress_kibana" {
  source_name      = "poc-ingress"
  destination_name = "kibana"
  action           = "allow"
}

resource "consul_intention" "ingress_grafana" {
  source_name      = "poc-ingress"
  destination_name = "grafana-internal"
  action           = "allow"
}

resource "consul_intention" "ingress_elastic" {
  source_name      = "poc-ingress"
  destination_name = "elastic-internal"
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

resource "consul_intention" "opentraced-app_kibana" {
  source_name      = "opentraced-app"
  destination_name = "kibana"
  action           = "allow"
}