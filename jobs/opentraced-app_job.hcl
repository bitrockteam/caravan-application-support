job "opentraced-app" {
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
        }

        service {
          name = "opentraced-app"
          port = "http"

          tags = [
            "springboot"
          ]

          connect {
            sidecar_service { }
            sidecar_task {
                name  = "connect-opentraced-app"
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
          name = "opentraced-app"
          port = "http_mgmt"

          tags = [
            "springboot", "actuator"
          ]

          connect {
            sidecar_service {}
            sidecar_task {
                name  = "connect-opentraced-app"
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
                opentracing:
                  jaeger:
                    service-name: springboot-app
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
                  "-jar", "local/OpenTracing-AppA-0.0.1-SNAPSHOT.jar"
                ]
            }

            artifact {
                source = "${artifacts_source_prefix}OpenTracing-AppA-0.0.1-SNAPSHOT.jar",
                destination = "local/"
            }
        }
    }
}