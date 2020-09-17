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

resource "consul_intention" "esm" {
  source_name      = "poc-esm"
  destination_name = "*"
  action           = "allow"
}
