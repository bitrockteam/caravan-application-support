job "echo-server" {
  datacenters = [
    %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
  ]

    constraint {
        attribute = "$${attr.unique.hostname}"
        operator  = "regexp"
        value     = "^defwrkr-"
    }

    group "echo-server-group" {
        network {
            mode = "bridge"
            port "http" {}
        }

        service {
          name = "echo-server"
          port = "http"

          connect {
              sidecar_service {
                  proxy {
                    upstreams {
                        destination_name = "kibana"
                        local_bind_port = 8080
                    }
                  }
              }
          }
          check {
            type     = "http"
            protocol = "http"
            port     = "http"
            interval = "25s"
            timeout  = "35s"
            path     = "/health"
          }
        }

        task "echo-server" {
            driver = "exec"

            resources {
                cpu    = 200
                memory = 250
            }
            template {
              data = "nameserver {{env `NOMAD_HOST_IP_http`}}"
              destination = "etc/resolv.conf"
            }

            artifact {
                source = "${artifacts_source_prefix}/echo-server",
                destination = "local/"
            }

            env {
              PORT="$${NOMAD_PORT_http}"
            }

            config {
                command = "local/echo-server"
            }
        }

    }

}