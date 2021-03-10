job "csi_controller" {
    datacenters = [
        %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]
    
  group "controller" {
    task "plugin" {
      driver = "docker"
       config {
         image = "amazon/aws-ebs-csi-driver:v0.9.0"
         args = [
            "controller",
            "--endpoint=unix:///csi/csi.sock",
            "--v=5",
            "--logtostderr",
         ],
         dns_servers = ["$${attr.unique.network.ip-address}"]
      }
      csi_plugin {
        id        = "${ plugin_id }"
        type      = "controller"
        mount_dir = "/csi"
      }
      resources {
        cpu    = 250
        memory = 256
      }
    }
  }
}
