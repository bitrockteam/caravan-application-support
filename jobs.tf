module "jaeger" {
  count                                    = var.configure_monitoring ? 1 : 0
  source                                   = "git::ssh://git@github.com/bitrockteam/caravan-cart//modules/jaeger?ref=refs/tags/v0.3.7"
  dc_names                                 = var.dc_names
  services_domain                          = var.services_domain
  elastic_service_name                     = "elastic-internal"
  jaeger_agent_service_name                = "jaeger-agent"
  artifact_source_jaeger_spark_dependecies = "https://bitrock-jars.s3.amazonaws.com/jaeger-spark-dependencies-0.0.1-SNAPSHOT.jar"
  jaeger_jobs_constraints                  = var.monitoring_jobs_constraint
  depends_on                               = [nomad_job.consul-ingress]
}

module "kibana" {
  count                   = var.configure_monitoring ? 1 : 0
  source                  = "git::ssh://git@github.com/bitrockteam/caravan-cart//modules/kibana?ref=refs/tags/v0.3.7"
  dc_names                = var.dc_names
  nameserver_dummy_ip     = var.nameserver_dummy_ip
  services_domain         = var.services_domain
  elastic_service_name    = "elastic-internal"
  kibana_jobs_constraints = var.monitoring_jobs_constraint
  depends_on              = [nomad_job.consul-ingress]
}

module "filebeat" {
  count           = var.configure_monitoring ? 1 : 0
  source          = "git::ssh://git@github.com/bitrockteam/caravan-cart//modules/filebeat?ref=refs/tags/v0.3.7"
  dc_names        = var.dc_names
  domain          = var.domain
  services_domain = var.services_domain
}

resource "nomad_job" "consul-ingress" {
  jobspec = templatefile(
    "${path.module}/jobs/consul-ingress.hcl",
    {
      dc_names               = var.dc_names
      domain                 = var.domain
      ingress_services       = var.ingress_services
      nameserver_dummy_ip    = var.nameserver_dummy_ip
      worker_jobs_constraint = var.worker_jobs_constraint
    }
  )
  depends_on = [consul_config_entry.proxy_defaults, consul_config_entry.ingress_gateway]
}

resource "nomad_job" "consul-terminating" {
  jobspec = templatefile(
    "${path.module}/jobs/consul-terminating.hcl",
    {
      dc_names               = var.dc_names
      services_domain        = var.services_domain
      terminating_services   = var.terminating_services
      nameserver_dummy_ip    = var.nameserver_dummy_ip
      worker_jobs_constraint = var.worker_jobs_constraint
    }
  )
  depends_on = [consul_config_entry.proxy_defaults, consul_config_entry.terminating_gateway]
}

resource "nomad_job" "consul-esm" {
  jobspec = templatefile(
    "${path.module}/jobs/consul-esm.hcl",
    {
      dc_names               = var.dc_names
      services_domain        = var.services_domain
      worker_jobs_constraint = var.worker_jobs_constraint
    }
  )
  depends_on = [consul_config_entry.proxy_defaults]
}
