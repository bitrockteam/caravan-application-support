job "jaeger-collector" {
    datacenters = [
        %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]

    type = "service"

    constraint {
        attribute = "$${meta.nodeType}"
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
            port "http_zipkin_span" {
                static = 9411
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
                    "--admin.http.host-port=0.0.0.0:$${NOMAD_PORT_http_admin}",
                    "--collector.grpc-server.host-port=0.0.0.0:$${NOMAD_PORT_http_span}",
                    "--collector.zipkin.http-port=$${NOMAD_PORT_http_zipkin_span}"
                ]
            }

            env {
                SPAN_STORAGE_TYPE = "elasticsearch"
                ES_SERVER_URLS = "http://elastic-internal.${services_domain}:9200"
            }
        }
    }
}
