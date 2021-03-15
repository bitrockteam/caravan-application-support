module "logstash" {
  count                     = var.configure_monitoring ? 1 : 0
  source                    = "git::ssh://git@github.com/bitrockteam/caravan-cart//modules/logstash?ref=refs/tags/v0.3.7"
  dc_names                  = var.dc_names
  services_domain           = var.services_domain
  elastic_service_name      = "elastic-internal"
  logstash_jobs_constraints = var.monitoring_jobs_constraint
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
