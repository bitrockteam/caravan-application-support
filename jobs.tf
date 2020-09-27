locals {
  jobs = { for f in fileset(path.module, "jobs/*_job.hcl") : basename(trimsuffix(f, "_job.hcl")) => f }
}

resource "nomad_job" "app" {
  for_each = local.jobs
  jobspec  = file(each.value)
}

resource "nomad_job" "logstash" {
  jobspec = file("${path.module}/jobs/logstash.hcl")
}

resource "nomad_job" "consul-ingress" {
  jobspec = file("${path.module}/jobs/consul-ingress.hcl")
}

resource "nomad_job" "consul-terminating" {
  jobspec = file("${path.module}/jobs/consul-terminating.hcl")
}

resource "nomad_job" "consul-esm" {
  jobspec = file("${path.module}/jobs/consul-esm.hcl")
}