job "opentraced-app-b" {
    datacenters = [
        %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]

    constraint {
        attribute = "$${attr.unique.hostname}"
        operator  = "regexp"
        value     = "^defwrkr-"
    }

    group "java-springboot" {
        network {
            mode = "bridge"
            port "http" {}
            port "http_mgmt" {}
            port "envoy_prom" {
              static = "29103"
              to = "29103"
            }
        }

        service {
          name = "opentraced-app-b"
          port = "http"

          tags = [
            "springboot", "ProxyPromPort:29103"
          ]

          connect {
            sidecar_service {

                proxy {
                    upstreams {
                      destination_name = "opentraced-app"
                      local_bind_port  = 8080
                    }
                    config {
                        envoy_prometheus_bind_addr = "0.0.0.0:29103"
                        envoy_tracing_json = "{\n  \"http\": {\n    \"name\": \"envoy.tracers.dynamic_ot\",\n    \"config\": {\n      \"library\": \"/usr/local/lib/libjaegertracing_plugin.so\",\n      \"config\": {\n        \"service_name\": \"opentraced-app\",\n        \"sampler\": {\n          \"type\": \"const\",\n          \"param\": 1\n        },\n        \"reporter\": {\n          \"localAgentHostPort\": \"jaeger-agent.service.consul:6831\"\n        }\n      }\n    }\n  }\n}"
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
                        "$${meta.connect.log_level}"
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
        task "java-springboot" {
            driver = "exec"

            resources {
                cpu    = 200
                memory = 2048
            }
            template {
              data = "nameserver {{env `NOMAD_HOST_IP_http`}}"
              destination = "etc/resolv.conf"
            }
            template {
              data = <<-EOT
                spring:
                  application:
                    name: springboot-app-b
                opentracing:
                  jaeger:
                    service-name: springboot-app-b
                    enabled: true
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
                source = "${artifacts_source_prefix}OpenTracing-AppB-0.0.1-SNAPSHOT.jar",
                destination = "local/"
            }
        }
    }
}
