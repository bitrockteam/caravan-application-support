resource "nomad_job" "poc-esm" {
  jobspec = file("${path.module}/jobs/poc-esm.hcl")
}