data "nomad_plugin" "gcepd" {
  count            = var.cloud == "gcp" ? 1 : 0
  depends_on       = [
    nomad_job.csi
  ]
  plugin_id        = "gcepd"
  wait_for_healthy = true
}
resource "nomad_volume" "jenkins_master" {
  count           = var.cloud == "gcp" ? 1 : 0
  depends_on      = [
    nomad_job.csi,
    data.nomad_plugin.gcepd
  ]
  type            = "csi"
  plugin_id       = "gcepd"
  volume_id       = "jenkins-master"
  name            = "jenkins-master"
  external_id     = "projects/${var.gcp_project_id}/regions/${var.gcp_region}/disks/jenkins-master"
  access_mode     = "single-node-writer"
  attachment_mode = "file-system"
}
