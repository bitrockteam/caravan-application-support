job "jaeger-agent" {
    datacenters = ["hcpoc"]

    type = "service"

    constraint {
        attribute = "${attr.unique.hostname}"
        operator  = "="
        value     = "monitoring"
    }

    group "agent" {

        network {
            mode = "host"
            port "http" {
                static = 14271
            }
        }
        service {
            name = "jaeger-agent"
            tags = [ "monitoring" ]
            port = "http",
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
                    "--reporter.grpc.host-port=127.0.0.1:14250",
                    "--processor.jaeger-compact.server-host-port=0.0.0.0:6831",
                    "--reporter.grpc.discovery.min-peers=1"
                ]
            }
        }
    }
}