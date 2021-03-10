job "csi_nodes" {
    datacenters = [
        %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]
  type = "system"
  group "nodes" {
    task "plugin" {
      driver = "docker"
      config {
        image = "amazon/aws-ebs-csi-driver:v0.9.0"
        args = [
          "node",
          "--endpoint=unix:///csi/csi.sock",
          "--v=5",
          "--logtostderr"
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
        cpu    = 250
        memory = 256
      }
    }
  }
}
