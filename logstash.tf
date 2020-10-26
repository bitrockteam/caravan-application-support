resource "nomad_job" "logstash" {
  jobspec = templatefile(
    "${path.module}/jobs/logstash.hcl",
    {
      dc_names              = var.dc_names
      services_domain       = var.services_domain
      logstash_index_prefix = var.logstash_index_prefix
    }
  )
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
resource "consul_config_entry" "logstash-tcp-service-defaults" {
  name = "logstash-tcp"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "tcp"
  })
}
