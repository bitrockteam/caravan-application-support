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
            port "http_envoy_prom" {
              to = "9102"
            }
            dns {
                servers = ["192.168.0.1", "8.8.8.8"]
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
                        config {
                            protocol = "http"
                            envoy_prometheus_bind_addr = "0.0.0.0:9102"
                            envoy_extra_static_clusters_json = "{\n  \"connect_timeout\": \"3.000s\",\n  \"dns_lookup_family\": \"V4_ONLY\",\n  \"lb_policy\": \"ROUND_ROBIN\",\n  \"load_assignment\": {\n      \"cluster_name\": \"jaeger_9411\",\n      \"endpoints\": [\n          {\n              \"lb_endpoints\": [\n                  {\n                      \"endpoint\": {\n                          \"address\": {\n                              \"socket_address\": {\n                                  \"address\": \"monitoring.node.consul\",\n                                  \"port_value\": 9411,\n                                  \"protocol\": \"TCP\"\n                              }\n                          }\n                      }\n                  }\n              ]\n          }\n      ]\n  },\n  \"name\": \"jaeger_9411\",\n  \"type\": \"STRICT_DNS\"\n}\n",
                            envoy_tracing_json = "{\n  \"http\": {\n      \"typed_config\": {\n          \"@type\": \"type.googleapis.com/envoy.config.trace.v2.ZipkinConfig\",\n          \"collector_cluster\": \"jaeger_9411\",\n          \"collector_endpoint\": \"/api/v2/spans\",\n          \"shared_span_context\": false,\n          \"collector_endpoint_version\": \"HTTP_JSON\"\n      },\n      \"name\": \"envoy.tracers.zipkin\"\n  }\n}\n"
                        }
                    }
                }
            }

        }

        service {
          name = "kibana"
          port = "http_envoy_prom"

          tags = [
            "envoy", "prometheus"
          ]
        }

        task "kibana" {
            driver = "docker"

            config {
                image = "${container_registry}/kibana/kibana:7.9.1"
            }

            env {
                SERVER_NAME = "kibana.${domain}"
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
