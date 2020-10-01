job "logstash" {
  datacenters = [
    %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
  ]

  group "service_group" {
      ephemeral_disk {
        migrate = true
        size    = "500"
        sticky  = true
      }
      network {
        mode = "host"
        port "http" {}
        port "api" {}
        port "tcp" {}
      },
      service {
        name = "logstash-http",
        port = "http"

        check {
          type     = "http"
          protocol     = "http"
          port     = "http"
          interval = "25s"
          timeout  = "35s"
          path     = "/health"
        }
      }
      service {
        name = "logstash-api",
        port = "api"

        check {
          type     = "http"
          protocol = "http"
          port     = "api"
          interval = "25s"
          timeout  = "35s"
          path     = "/"
        }
      }
      service {
        name = "logstash-tcp",
        port = "tcp"

        check {
          type     = "tcp"
          port     = "tcp"
          interval = "25s"
          timeout  = "35s"
        }
      }
      task "logstash" {
        template {
          destination = "local/config/logstash.yml"
          data = <<-EOT
            input {
              http {
                port => {{env `NOMAD_PORT_http`}}
                codec => json
              }
            }
            input {
              tcp {
                port => {{env `NOMAD_PORT_tcp`}}
                codec => json
              }
            }
            output {
              elasticsearch {
                index => "poclogs-%%{+MMdd}"
                hosts => "http://elastic-internal.${services_domain}:9200"
              }
            }
          EOT
        }

        template {
          data = "nameserver {{env `NOMAD_HOST_IP_http`}}"
          destination = "etc/resolv.conf"
        }

        config {
          command = "/usr/share/logstash/bin/logstash"
          args = [
            "--path.data", "alloc/data",
            "--path.config", "local/config",
            "--path.logs", "alloc/data/logs",
            "--http.port", "$${NOMAD_PORT_api}",
            "--http.host", "0.0.0.0"
          ]
        }
        driver = "exec",
        resources = {
          cpu = 400
          memory = 1024
        }
      }
    }
  }
