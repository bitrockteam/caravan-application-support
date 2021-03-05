job "kibana" {
    datacenters = [
        %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]

    type = "service"

    %{ for constraint in monitoring_jobs_constraint ~}
    constraint {
        %{ for key, value in constraint ~}
        "${key}" = "${value}"
        %{ endfor ~}
    }
    %{ endfor ~}

    group "kibana-group" {
        network {
            mode = "bridge"
            port "http_envoy_prom" {
              to = "9102"
            }
            dns {
                servers = ["${nameserver_dummy_ip}"]
            }
        }

        service {
            name = "kibana"
            tags = [ "monitoring" ]
            port = 5601,
            meta {
              envoy_metrics_port = "$${NOMAD_HOST_PORT_http_envoy_prom}"
            }
            check {
                expose = true
                name = "kibana-health"
                type = "http"
                path = "/api/status"
                interval = "5s"
                timeout = "2s"
            }
            connect {
                sidecar_service {
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
                image = "docker.elastic.co/kibana/kibana:7.10.2"
            }

            env {
                SERVER_NAME = "kibana.${domain}"
                ELASTICSEARCH_HOSTS = "http://localhost:9200"
                TELEMETRY_ENABLED = "false"
                MONITORING_UI_CONTAINER_ELASTICSEARCH_ENABLED = "false"
                STATUS.ALLOWANONYMOUS = "true"
                XPACK_SECURITY_ENABLED = "false"
            }

            resources {
                cpu    = 300
                memory = 1000
            }

        }
    }
}
