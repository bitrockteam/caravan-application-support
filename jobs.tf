locals {
  monitoring_jobs = var.configure_monitoring ? { for f in fileset(path.module, "jobs/monitoring/*_job.hcl") : basename(trimsuffix(f, "_job.hcl")) => f } : {}
  workload_jobs   = { for f in fileset(path.module, "jobs/*_job.hcl") : basename(trimsuffix(f, "_job.hcl")) => f }
}

resource "nomad_job" "monitoring" {
  for_each = local.monitoring_jobs
  jobspec = templatefile(
    each.value,
    {
      dc_names                = var.dc_names
      services_domain         = var.services_domain
      artifacts_source_prefix = var.artifacts_source_prefix
      container_registry      = var.container_registry
      domain                  = var.domain
      nameserver_dummy_ip     = var.nameserver_dummy_ip
      logstash_index_prefix   = var.logstash_index_prefix
    }
  )
}

resource "nomad_job" "openfaas" {
  count = var.configure_openfaas ? 1 : 0
  jobspec = templatefile(
    "jobs/openfaas/faasd_bundle_job.hcl",
    {
      dc_names = var.dc_names
    }
  )
}

resource "nomad_job" "workloads" {
  for_each = local.workload_jobs
  jobspec = templatefile(
    each.value,
    {
      dc_names                = var.dc_names
      services_domain         = var.services_domain
      artifacts_source_prefix = var.artifacts_source_prefix
      container_registry      = var.container_registry
      domain                  = var.domain
      nameserver_dummy_ip     = var.nameserver_dummy_ip
    }
  )
}

resource "nomad_job" "consul-ingress" {
  jobspec = templatefile(
    "${path.module}/jobs/consul-ingress.hcl",
    {
      dc_names        = var.dc_names
      services_domain = var.services_domain
    }
  )
}

resource "nomad_job" "consul-terminating" {
  jobspec = templatefile(
    "${path.module}/jobs/consul-terminating.hcl",
    {
      dc_names        = var.dc_names
      services_domain = var.services_domain
    }
  )
}

resource "nomad_job" "consul-esm" {
  jobspec = templatefile(
    "${path.module}/jobs/consul-esm.hcl",
    {
      dc_names        = var.dc_names
      services_domain = var.services_domain
    }
  )
}
