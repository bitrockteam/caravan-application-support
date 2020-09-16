locals {
  jobs = { for f in fileset(path.module, "jobs/*_job.hcl") : basename(trimsuffix(f, "_job.hcl")) => f }
}
resource "nomad_job" "app" {
  for_each = local.jobs
  jobspec  = file(each.value)
}
