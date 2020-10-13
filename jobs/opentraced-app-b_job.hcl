job "opentraced-app-b" {
    datacenters = [
        %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]

    constraint {
        attribute = "$${attr.unique.hostname}"
        operator  = "regexp"
        value     = "^defwrkr-"
    }

    group "java-springboot-b" {
        network {
            mode = "bridge"
            port "http" {}
            port "http_mgmt" {}
            port "http_envoy_prom" {
              to = "9102"
            }
            dns {
                servers = ["192.168.0.1"]
            }
        }

        service {
          name = "opentraced-app-b"
          port = "http"

          tags = [
            "springboot"
          ]

          connect {
            sidecar_service {

                proxy {
                    upstreams {
                      destination_name = "opentraced-app"
                      local_bind_port  = 8080
                    }
                    config {
                        protocol = "http"
                        envoy_prometheus_bind_addr = "0.0.0.0:9102"
                        envoy_extra_static_clusters_json = "{\n  \"connect_timeout\": \"3.000s\",\n  \"dns_lookup_family\": \"V4_ONLY\",\n  \"lb_policy\": \"ROUND_ROBIN\",\n  \"load_assignment\": {\n      \"cluster_name\": \"jaeger_9411\",\n      \"endpoints\": [\n          {\n              \"lb_endpoints\": [\n                  {\n                      \"endpoint\": {\n                          \"address\": {\n                              \"socket_address\": {\n                                  \"address\": \"10.128.0.4\",\n                                  \"port_value\": 9411,\n                                  \"protocol\": \"TCP\"\n                              }\n                          }\n                      }\n                  }\n              ]\n          }\n      ]\n  },\n  \"name\": \"jaeger_9411\",\n  \"type\": \"STRICT_DNS\"\n}\n",
                        envoy_tracing_json = "{\n  \"http\": {\n      \"typed_config\": {\n          \"@type\": \"type.googleapis.com/envoy.config.trace.v2.ZipkinConfig\",\n          \"collector_cluster\": \"jaeger_9411\",\n          \"collector_endpoint\": \"/api/v2/spans\",\n          \"shared_span_context\": false,\n          \"collector_endpoint_version\": \"HTTP_JSON\"\n      },\n      \"name\": \"envoy.tracers.zipkin\"\n  }\n}\n"
                    }
                }
            }
            sidecar_task {
                driver = "exec"
                config {
                    command = "/usr/bin/envoy"
                    args  = [
                        "-c",
                        "$${NOMAD_SECRETS_DIR}/envoy_bootstrap.json",
                        "-l",
                        "$${meta.connect.log_level}",
                        "--disable-hot-restart"
                    ]
                }
            }
          }
          check {
            type     = "http"
            protocol = "http"
            port     = "http_mgmt"
            interval = "25s"
            timeout  = "35s"
            path     = "/actuator/health"
          }
        }

        service {
          name = "opentraced-app-b"
          port = "http_mgmt"

          tags = [
            "springboot", "actuator"
          ]


          check {
            type     = "http"
            protocol = "http"
            port     = "http_mgmt"
            interval = "25s"
            timeout  = "35s"
            path     = "/actuator/health"
          }
        }

        service {
          name = "opentraced-app-b"
          port = "http_envoy_prom"

          tags = [
            "envoy", "prometheus"
          ]
        }

        task "loopback" {
            lifecycle {
                hook = "prestart"
            }
            driver = "exec"
            user = "root"
            config = {
                command = "/sbin/ifup"
                args = ["lo"]
            }
        }
        task "java-springboot-b" {
            driver = "exec"

            resources {
                cpu    = 200
                memory = 2048
            }
            
            template {
              data = <<-EOT
                spring:
                  application:
                    name: springboot-app-b
                opentracing:
                  jaeger:
                    service-name: springboot-app-b
                    enabled: TRUE
                    udp-sender:
                      host: jaeger-agent.${services_domain}
                      port: 6831
                management:
                  endpoints:
                    web:
                      exposure:
                        include: "*"
              EOT
              destination = "local/application.yml"
            }
            env {
              SERVER_PORT="$${NOMAD_PORT_http}"
              MANAGEMENT_SERVER_PORT="$${NOMAD_PORT_http_mgmt}"
            }
            config {
                command = "/bin/java"
                args =  [
                  "-Xmx2048m",
                  "-Xms256m",
                  "-Dspring.config.location=local/application.yml",
                  "-jar", "local/OpenTracing-AppB-0.0.1-SNAPSHOT.jar"
                ]
            }

            artifact {
                source = "${artifacts_source_prefix}/OpenTracing-AppB-0.0.1-SNAPSHOT.jar",
                destination = "local/"
            }
        }
    }
}
