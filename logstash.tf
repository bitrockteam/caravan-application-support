resource "nomad_job" "logstash" {
  jobspec = file("${path.module}/jobs/logstash.hcl")
}

resource "consul_config_entry" "logstash-tcp-service-defaults" {
  name = "logstash-tcp"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "tcp"
  })
}
