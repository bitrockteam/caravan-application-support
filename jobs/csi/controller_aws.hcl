job "csi_controller" {
    datacenters = [
        %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]
    
  group "controller" {
    task "plugin" {
      driver = "docker"
       config {
         image = "amazon/aws-ebs-csi-driver:latest"
         args = [
            "--endpoint=unix:///csi/csi.sock",
            "--v=5",
            "--logtostderr",
            "--run-node-service=false"
         ],
         dns_servers = ["$${attr.unique.network.ip-address}"]
      }
      csi_plugin {
        id        = "${ plugin_id }"
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
