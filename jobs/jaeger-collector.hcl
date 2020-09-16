job "jaeger-collector" {
    datacenters = ["hcpoc"]

    type = "service"

    constraint {
        attribute = "${attr.unique.hostname}"
        operator  = "="
        value     = "monitoring"
    }

    group "collector" {
        network {
            mode = "host"
            port "http" {
                static = 14268
            }
            port "http_admin" {
                static = 14269
            }
            port "http_span" {
                static = 14250
            }
        }
        service {
            name = "jaeger-collector"
            tags = [ "monitoring" ]
            port = "http_span",
            check {
                type = "http"
                port = "http_admin"
                path = "/"
                interval = "5s"
                timeout = "2s"
            }
        }

        task "collector" {
            driver = "exec"

            template {
              data = "nameserver {{env `NOMAD_HOST_IP_http`}}"
              destination = "etc/resolv.conf"
            }

            config {
                command = "/usr/local/bin/jaeger-collector"
                args = [
                    "--admin.http.host-port=0.0.0.0:${NOMAD_PORT_http_admin}",
                    "--collector.grpc-server.host-port=127.0.0.1:${NOMAD_PORT_http_span}"
                ]
            }

            env {
                SPAN_STORAGE_TYPE = "elasticsearch"
                ES_SERVER_URLS = "http://elastic-internal.service.hcpoc.consul:9200"
            }
        }
    }
}