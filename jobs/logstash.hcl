job "logstash" {
  datacenters = [
    "hcpoc"
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
          protocol     = "http"
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
        artifact {
          destination = "local/"
          source = "gcs::https://www.googleapis.com/storage/v1/cfgs-bmed-1181724079/logstash-7.9.0.tar.gz"
        }
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
                index => "poclogs-%{+MMdd}"
                hosts => "http://elastic-internal.service.hcpoc.consul:9200"
              }
            }
          EOT
        }
        config {
          command = "local/logstash-7.9.0/bin/logstash"
          args = [
            "--path.data", "alloc/data",
            "--path.config", "local/config",
            "--path.logs", "alloc/data/logs",
            "--http.port", "${NOMAD_PORT_api}",
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