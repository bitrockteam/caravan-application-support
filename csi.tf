locals {
  csi_jobs = { for f in fileset(path.module, "jobs/csi/*_${var.cloud}.hcl") : basename(trimsuffix(f, "_${var.cloud}.hcl")) => f }

  gcp_plugin_id = "gcepd"
  aws_plugin_id = "aws-ebs"
  cloud_to_csi_plugin_id = {
    "gcp" : local.gcp_plugin_id
    "aws" : local.aws_plugin_id
  }
}

resource "nomad_job" "csi" {
  for_each = local.csi_jobs
  jobspec = templatefile(
    each.value,
    {
      dc_names  = var.dc_names
      plugin_id = local.cloud_to_csi_plugin_id[var.cloud]
    }
  )
}
