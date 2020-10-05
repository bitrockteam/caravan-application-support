job "kibana" {
    datacenters = [
        %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]

    type = "service"

    constraint {
        attribute = "$${attr.unique.hostname}"
        operator  = "="
        value     = "monitoring"
    }

    group "kibana-group" {
        network {
            mode = "bridge"
            port "http" {
                static = 5601
                to = 5601
            }
            dns {
                servers = ["10.128.0.10", "8.8.8.8"]
            }
        }
        service {
            name = "kibana"
            tags = [ "monitoring" ]
            port = "http",
            check {
                type = "http"
                port = "http"
                path = "/api/status"
                interval = "5s"
                timeout = "2s"
            }
            connect {
                sidecar_service {
                    port = "http"
                    proxy {
                    upstreams {
                        destination_name = "elastic-internal"
                        local_bind_port = 9200
                    }
                  }
                }
            }

        }

        task "kibana" {
            driver = "docker"

            config {
                image = "docker.elastic.co/kibana/kibana:7.9.1"
            }

            env {
                SERVER_NAME = "kibana.$${subdomain}.cloud.bitrock.it"
                SERVER_PORT = "$${NOMAD_PORT_http}"
                ELASTICSEARCH_HOSTS = "http://localhost:9200"
                TELEMETRY_ENABLED = "false"
                MONITORING_UI_CONTAINER_ELASTICSEARCH_ENABLED = "false"
                STATUS.ALLOWANONYMOUS = "true"
            }

            resources {
                cpu    = 300
                memory = 1000
            }

        }
    }
}
