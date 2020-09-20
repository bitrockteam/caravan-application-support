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

resource "consul_intention" "ingress_echo_service" {
  source_name      = "poc-ingress"
  destination_name = "spring-echo-example"
  action           = "allow"
}

resource "consul_intention" "ingress_jaeger_query" {
  source_name      = "poc-ingress"
  destination_name = "jaeger-query"
  action           = "allow"
}

resource "consul_intention" "jaeger-query-jaeger-collector" {
  source_name      = "jaeger-query"
  destination_name = "jaeger-collector"
  action           = "allow"
}

resource "consul_intention" "jaeger-collector-elastic-internal" {
  source_name      = "jaeger-collector"
  destination_name = "elastic-internal"
  action           = "allow"
}

resource "consul_intention" "jaeger-query-elastic-internal" {
  source_name      = "jaeger-query"
  destination_name = "elastic-internal"
  action           = "allow"
}
