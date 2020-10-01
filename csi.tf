locals {
  csi_jobs = { for f in fileset(path.module, "jobs/csi/*_${var.cloud}.hcl") : basename(trimsuffix(f, "_${var.cloud}.hcl")) => f }
}

resource "nomad_job" "csi" {
  for_each = local.csi_jobs
  jobspec = templatefile(
    each.value,
    {
      dc_names = var.dc_names
    }
  )
}
