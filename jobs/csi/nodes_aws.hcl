job "csi_nodes" {
    datacenters = [
        %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]
  type = "system"
  group "nodes" {
    task "plugin" {
      driver = "docker"
      config {
        image = "amazon/aws-ebs-csi-driver:latest"
        args = [
          "--endpoint=unix:///csi/csi.sock",
          "--v=5",
          "--logtostderr"
        ],
        dns_servers = ["$${attr.unique.network.ip-address}"]
        privileged = true
      }
      csi_plugin {
        id        = "{{ plugin_id }}"
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
