job "nodes" {
    datacenters = [
        %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]
  type = "system"
  group "nodes" {
    task "plugin" {
      driver = "docker"
      template {
        data = <<EOH
{{ with secret "secret/gcp/pd_csi_sa_credential" }}
{{- .Data.credential_json -}}
{{ end }}
EOH
  destination = "secrets/credential.json"
      }
      env { "GOOGLE_APPLICATION_CREDENTIALS" = "/secrets/credential.json"
      }
      config {
        image = "gcr.io/gke-release/gcp-compute-persistent-disk-csi-driver:v0.7.0-gke.0"
        args = [
          "--endpoint=unix:///csi/csi.sock",
          "--v=6",
          "--logtostderr",
          "--run-controller-service=false"
        ]
        privileged = true
      }
      csi_plugin {
        id        = "gcepd"
        type      = "node"
        mount_dir = "/csi"
      }
      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
