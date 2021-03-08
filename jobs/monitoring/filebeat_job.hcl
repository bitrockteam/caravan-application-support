job "filebeat" {
  datacenters = [
    %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
  ]

  type = "system"

  group "agents" {
    ephemeral_disk {
      migrate = true
      size = "500"
      sticky = true
    }
    network {
      mode = "host"
      port "http" {
        static = 5066
      }
    },
    service {
      name = "filebeat",
      port = "http"

      check {
        type = "http"
        protocol = "http"
        port = "http"
        interval = "10s"
        timeout = "2s"
        path = "/?pretty"
      }
    }
    task "filebeat" {
      template {
        destination = "local/config/filebeat.yml"
        data = <<-EOT
            http.enabled: true
            http.host: 0.0.0.0
            output.file.enabled: false
            logging.to_files: false
            logging.to_stderr: true
            logging.level: info
            filebeat.registry.flush: 5s

            filebeat.inputs:
              - type: log
                enabled: true
                paths:
                  - /var/log/*.log
                  - /var/lib/nomad/alloc/*/alloc/logs/*.std*.[0-9]*

            output.elasticsearch:
              hosts: ["elastic-internal.${services_domain}"]
            setup.kibana:
              host: "kibana.${domain}"
            processors:
              - add_host_metadata:
                  when.not.contains.tags: forwarded
              - add_cloud_metadata: ~
              - add_docker_metadata: ~
          EOT
      }

      template {
        data = "nameserver {{env `NOMAD_HOST_IP_http`}}"
        destination = "etc/resolv.conf"
      }

      config {
        command = "/usr/share/filebeat/bin/filebeat"
        args = [
          "--path.config",
          "local/config"
        ]
      }
      driver = "raw_exec",
      user = "root"
      resources = {
        cpu = 500
        memory = 128
      }
    }
  }
}
