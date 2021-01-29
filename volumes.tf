locals {
  cloud_to_csi_plugin_id = {
    "gcp" : "gcepd"
  }
}

// GCP
data "nomad_plugin" "gcepd" {
  count = var.cloud == "gcp" ? 1 : 0
  depends_on = [
    nomad_job.csi
  ]
  plugin_id        = local.cloud_to_csi_plugin_id[var.cloud]
  wait_for_healthy = true
}
resource "nomad_volume" "jenkins_master" {
  count = var.cloud == "gcp" ? 1 : 0
  depends_on = [
    nomad_job.csi,
    data.nomad_plugin.gcepd
  ]
  type            = "csi"
  plugin_id       = local.cloud_to_csi_plugin_id[var.cloud]
  volume_id       = "jenkins-master"
  name            = "jenkins-master"
  external_id     = var.jenkins_volume_external_id
  access_mode     = "single-node-writer"
  attachment_mode = "file-system"
}
