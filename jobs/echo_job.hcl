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
            port "http_envoy_prom" {
              to = "9102"
            }
        }

        service {
          name = "echo-server"
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
                        envoy_prometheus_bind_addr = "0.0.0.0:9102"
                        envoy_extra_static_clusters_json = "{\n  \"connect_timeout\": \"3.000s\",\n  \"dns_lookup_family\": \"V4_ONLY\",\n  \"lb_policy\": \"ROUND_ROBIN\",\n  \"load_assignment\": {\n      \"cluster_name\": \"jaeger_9411\",\n      \"endpoints\": [\n          {\n              \"lb_endpoints\": [\n                  {\n                      \"endpoint\": {\n                          \"address\": {\n                              \"socket_address\": {\n                                  \"address\": \"10.128.0.4\",\n                                  \"port_value\": 9411,\n                                  \"protocol\": \"TCP\"\n                              }\n                          }\n                      }\n                  }\n              ]\n          }\n      ]\n  },\n  \"name\": \"jaeger_9411\",\n  \"type\": \"STRICT_DNS\"\n}\n",
                        envoy_tracing_json = "{\n  \"http\": {\n      \"config\": {\n          \"collector_cluster\": \"jaeger_9411\",\n          \"collector_endpoint\": \"/api/v2/spans\",\n          \"shared_span_context\": false,\n          \"collector_endpoint_version\": \"HTTP_JSON\"\n      },\n      \"name\": \"envoy.zipkin\"\n  }\n}\n"
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
          name = "echo-server"
          port = "http_envoy_prom"

          tags = [
            "envoy", "prometheus"
          ]
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