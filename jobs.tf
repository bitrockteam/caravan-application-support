locals {
  jobs = { for f in fileset(path.module, "jobs/*_job.hcl") : basename(trimsuffix(f, "_job.hcl")) => f }
}

resource "nomad_job" "app" {
  for_each = local.jobs
  jobspec = templatefile(
    each.value,
    {
      dc_names                = var.dc_names
      services_domain         = var.services_domain
      artifacts_source_prefix = var.artifacts_source_prefix
      container_registry      = var.container_registry
      domain                  = var.domain
    }
  )
}

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
