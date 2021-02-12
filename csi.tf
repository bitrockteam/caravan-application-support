locals {
  csi_jobs    = { for f in fileset(path.module, "jobs/csi/*_${var.cloud}.hcl") : basename(trimsuffix(f, "_${var.cloud}.hcl")) => f }
  csi_enabled = contains(keys(local.cloud_to_csi_plugin_id), var.cloud) ? 1 : 0

  gcp_plugin_id   = "gcepd"
  aws_plugin_id   = "aws-ebs"
  azure_plugin_id = "az-disk"
  cloud_to_csi_plugin_id = {
    "gcp" : local.gcp_plugin_id
    "aws" : local.aws_plugin_id
    "azure" : local.azure_plugin_id
  }
}

resource "nomad_job" "csi" {
  for_each = local.csi_jobs
  jobspec = templatefile(
    each.value,
    {
      dc_names              = var.dc_names
      plugin_id             = local.cloud_to_csi_plugin_id[var.cloud]
      azure_cloud           = var.azure_cloud_environment
      azure_tenant_id       = var.azure_tenant_id
      azure_subscription_id = var.azure_subscription_id
    }
  )
}
