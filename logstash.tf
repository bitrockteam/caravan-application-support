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

resource "consul_config_entry" "logstash-tcp" {
  name = "logstash-tcp"
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
resource "consul_config_entry" "logstash-http" {
  name = "logstash-http"
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
resource "consul_config_entry" "logstash-tcp-service-defaults" {
  name = "logstash-tcp"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "tcp"
  })
}
