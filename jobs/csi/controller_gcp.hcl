job "csi_controller" {
    datacenters = [
        %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]
    
  group "controller" {
    task "plugin" {
      driver = "docker"
      template {
        data = <<EOH
{{ with secret "secret/gcp/pd_csi_sa_credential" }}
{{- .Data.data.credential_json -}}
{{ end }}
EOH
  destination = "secrets/credential.json"
      }
       env {
           "GOOGLE_APPLICATION_CREDENTIALS" = "/secrets/credential.json"
        }
      config {
        image = "gcr.io/gke-release/gcp-compute-persistent-disk-csi-driver:v1.0.1-gke.0"
       args = [
          "--endpoint=unix:///csi/csi.sock",
          "--v=6",
          "--logtostderr",
          "--run-node-service=false"
        ],
        dns_servers = ["${attr.unique.network.ip-address}"]
      }
      csi_plugin {
        id        = "gcepd"
        type      = "controller"
        mount_dir = "/csi"
      }
      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
