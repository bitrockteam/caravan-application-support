job "jaeger-agent" {
  datacenters = [
    %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
  ]

    type = "system"

  %{ for constraint in monitoring_jobs_constraint ~}
  constraint {
    %{ for key, value in constraint ~}
    "${key}" = "${value}"
    %{ endfor ~}
  }
  %{ endfor ~}

    group "agent" {

        network {
            mode = "host"
            port "http" {
                static = 14271
            }
            port "compact" {
                static = 6831
            }
        }
        service {
            name = "jaeger-agent"
            tags = [ "monitoring" ]
            port = "http"
            check {
                type = "http"
                port = "http"
                path = "/"
                interval = "5s"
                timeout = "2s"
            }
        }

        task "agent" {
            driver = "exec"

            config {
                command = "/usr/local/bin/jaeger-agent"
                args = [
                    "--reporter.grpc.host-port=jaeger-collector.${services_domain}:14250",
                    "--processor.jaeger-compact.server-host-port=0.0.0.0:$${NOMAD_PORT_compact}",
                    "--reporter.grpc.discovery.min-peers=1"
                ]
            }
        }
    }
}
