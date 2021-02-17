resource "nomad_job" "logstash" {
  count = var.configure_monitoring ? 1 : 0
  jobspec = templatefile(
    "${path.module}/jobs/monitoring/logstash_job.hcl",
    {
      dc_names              = var.dc_names
      services_domain       = var.services_domain
      logstash_index_prefix = var.logstash_index_prefix
    }
  )
}

resource "consul_config_entry" "logstash-tcp" {
  count = var.configure_monitoring ? 1 : 0
  name  = "logstash-tcp"
  kind  = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "*"
      Precedence = 8
      Type       = "consul"
    }]
  })
}
resource "consul_config_entry" "logstash-http" {
  count = var.configure_monitoring ? 1 : 0
  name  = "logstash-http"
  kind  = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = "*"
      Precedence = 8
      Type       = "consul"
    }]
  })
}
resource "consul_config_entry" "logstash-tcp-service-defaults" {
  count = var.configure_monitoring ? 1 : 0
  name  = "logstash-tcp"
  kind  = "service-defaults"

  config_json = jsonencode({
    Protocol = "tcp"
  })
}
