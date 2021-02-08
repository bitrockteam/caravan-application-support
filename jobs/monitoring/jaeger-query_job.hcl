job "jaeger-query" {
    datacenters = [
        %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]

    type = "service"

    group "query" {
        network {
            mode = "host"
            port "http" {
                static = 16686
                to = 16686
            }
            port "http_admin" {}
        }
        service {
            name = "jaeger-query"
            tags = [ "monitoring" ]
            port = "http"
            
            check {
                type = "http"
                port = "http_admin"
                path = "/"
                interval = "5s"
                timeout = "2s"
            }

        }

        task "jaeger-query" {
            driver = "exec"

            template {
              data = "nameserver {{env `NOMAD_HOST_IP_http`}}"
              destination = "etc/resolv.conf"
            }

            config {
                command = "/usr/local/bin/jaeger-query"
                args = [
                    "--admin.http.host-port=0.0.0.0:$${NOMAD_PORT_http_admin}",
                    "--query.host-port=0.0.0.0:$${NOMAD_PORT_http}"
                ]
            }

            env {
                SPAN_STORAGE_TYPE = "elasticsearch"
                ES_SERVER_URLS = "http://elastic-internal.${services_domain}:9200"
                JAEGER_AGENT_HOST = "jaeger-agent.${services_domain}"
                JAEGER_AGENT_PORT = "6831"
            }
        }
    }
}