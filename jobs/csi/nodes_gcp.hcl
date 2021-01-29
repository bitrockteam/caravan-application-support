job "csi_nodes" {
    datacenters = [
        %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]
  type = "system"
  group "nodes" {
    task "plugin" {
      driver = "docker"
      template {
        data = <<EOH
{{ with secret "secret/gcp/pd_csi_sa_credentials" }}
{{- .Data.data.credentials_json -}}
{{ end }}
EOH
  destination = "secrets/credentials.json"
      }
      env { "GOOGLE_APPLICATION_CREDENTIALS" = "/secrets/credentials.json"
      }
      config {
        image = "gcr.io/gke-release/gcp-compute-persistent-disk-csi-driver:v1.0.1-gke.0"
        args = [
          "--endpoint=unix:///csi/csi.sock",
          "--v=6",
          "--logtostderr",
          "--run-controller-service=false"
        ],
        dns_servers = ["$${attr.unique.network.ip-address}"]
        privileged = true
      }
      csi_plugin {
        id        = "${ plugin_id }"
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
