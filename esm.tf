resource "nomad_job" "poc-esm" {
  jobspec = file("${path.module}/jobs/poc-esm.hcl")
}

resource "consul_intention" "esm" {
  source_name      = "poc-esm"
  destination_name = "*"
  action           = "allow"
}
