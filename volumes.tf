// Common
locals {
  configure_csi = contains(keys(local.cloud_to_csi_plugin_id), var.cloud) ? 1 : 0
}

data "nomad_plugin" "csi" {
  count = local.configure_csi
  depends_on = [
    nomad_job.csi
  ]
  plugin_id        = local.cloud_to_csi_plugin_id[var.cloud]
  wait_for_healthy = true
}

resource "nomad_volume" "jenkins_master" {
  count = local.configure_csi
  depends_on = [
    nomad_job.csi,
    data.nomad_plugin.csi
  ]
  type            = "csi"
  plugin_id       = local.cloud_to_csi_plugin_id[var.cloud]
  volume_id       = "jenkins-master"
  name            = "jenkins-master"
  external_id     = var.jenkins_volume_external_id
  access_mode     = "single-node-writer"
  attachment_mode = "file-system"
}
