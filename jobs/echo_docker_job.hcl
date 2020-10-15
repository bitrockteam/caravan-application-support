job "echo-server-dockerized" {
  datacenters = [
    %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
  ]

    constraint {
        attribute = "$${attr.unique.hostname}"
        operator  = "regexp"
        value     = "^defwrkr-"
    }

    group "echo-server-dockerized-group" {
        network {
            mode = "bridge"
            port "http" {}
            port "http_envoy_prom" {
              to = "9102"
            }
            dns {
                servers = ["192.168.0.1"]
            }
        }

        service {
          name = "echo-server-dockerized"
          port = "http"
          tags = []
          connect {
              sidecar_service {
                  proxy {
                    upstreams {
                        destination_name = "kibana"
                        local_bind_port = 8080
                    }
                    upstreams {
                        destination_name = "opentraced-app"
                        local_bind_port = 8081
                    }
                    upstreams {
                        destination_name = "opentraced-app-b"
                        local_bind_port = 8082
                    }
                    config {
                        protocol = "http"
                        envoy_prometheus_bind_addr = "0.0.0.0:9102"
                        envoy_extra_static_clusters_json = "{\n  \"connect_timeout\": \"3.000s\",\n  \"dns_lookup_family\": \"V4_ONLY\",\n  \"lb_policy\": \"ROUND_ROBIN\",\n  \"load_assignment\": {\n      \"cluster_name\": \"jaeger_9411\",\n      \"endpoints\": [\n          {\n              \"lb_endpoints\": [\n                  {\n                      \"endpoint\": {\n                          \"address\": {\n                              \"socket_address\": {\n                                  \"address\": \"10.128.0.4\",\n                                  \"port_value\": 9411,\n                                  \"protocol\": \"TCP\"\n                              }\n                          }\n                      }\n                  }\n              ]\n          }\n      ]\n  },\n  \"name\": \"jaeger_9411\",\n  \"type\": \"STRICT_DNS\"\n}\n",
                        envoy_tracing_json = "{\n  \"http\": {\n      \"typed_config\": {\n          \"@type\": \"type.googleapis.com/envoy.config.trace.v2.ZipkinConfig\",\n          \"collector_cluster\": \"jaeger_9411\",\n          \"collector_endpoint\": \"/api/v2/spans\",\n          \"shared_span_context\": false,\n          \"collector_endpoint_version\": \"HTTP_JSON\"\n      },\n      \"name\": \"envoy.tracers.zipkin\"\n  }\n}\n"
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

        service {
          name = "echo-server-dockerized"
          port = "http_envoy_prom"

          tags = [
            "envoy", "prometheus"
          ]
        }

        task "echo-server-dockerized" {
            driver = "docker"

            config {
                image = "${container_registry}/echo-server/echo-server:latest"
            }

            env {
              PORT="$${NOMAD_PORT_http}"
            }

            resources {
                cpu    = 200
                memory = 250
            }

        }

    }

}