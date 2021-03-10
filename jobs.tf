locals {
  monitoring_jobs = var.configure_monitoring ? { for f in fileset(path.module, "jobs/monitoring/*_job.hcl") : basename(trimsuffix(f, "_job.hcl")) => f } : {}
  workload_jobs   = { for f in fileset(path.module, "jobs/*_job.hcl") : basename(trimsuffix(f, "_job.hcl")) => f }
}

resource "nomad_job" "monitoring" {
  for_each = local.monitoring_jobs
  jobspec = templatefile(
    each.value,
    {
      dc_names                   = var.dc_names
      services_domain            = var.services_domain
      artifacts_source_prefix    = var.artifacts_source_prefix
      container_registry         = var.container_registry
      domain                     = var.domain
      nameserver_dummy_ip        = var.nameserver_dummy_ip
      logstash_index_prefix      = var.logstash_index_prefix
      monitoring_jobs_constraint = var.monitoring_jobs_constraint
    }
  )
  depends_on = [nomad_job.consul-ingress]
}

module "kibana" {
  source                  = "git::ssh://git@github.com/bitrockteam/caravan-cart//modules/kibana?ref=main"
  dc_names                = var.dc_names
  nameserver_dummy_ip     = var.nameserver_dummy_ip
  services_domain         = var.services_domain
  elastic_service_name    = "elastic-internal"
  kibana_jobs_constraints = var.monitoring_jobs_constraint
  depends_on              = [nomad_job.consul-ingress]
}

resource "nomad_job" "workloads" {
  for_each = local.workload_jobs
  jobspec = templatefile(
    each.value,
    {
      dc_names                   = var.dc_names
      services_domain            = var.services_domain
      artifacts_source_prefix    = var.artifacts_source_prefix
      container_registry         = var.container_registry
      domain                     = var.domain
      nameserver_dummy_ip        = var.nameserver_dummy_ip
      monitoring_jobs_constraint = var.monitoring_jobs_constraint
      worker_jobs_constraint     = var.worker_jobs_constraint
    }
  )
  depends_on = [nomad_job.consul-ingress]
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
  depends_on = [consul_config_entry.proxy_defaults]
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
  depends_on = [consul_config_entry.proxy_defaults]
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
