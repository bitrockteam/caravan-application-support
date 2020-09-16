job "opentracing_job" {
    datacenters = ["hcpoc"]

    constraint {
        attribute = "${attr.unique.hostname}"
        operator  = "regexp"
        value     = "-pool-def-wrkr-grp$"
    }

    group "app_group" {
        network {
            mode = "bridge"
            port "http" {}
            port "http_mgmt" {}
        }

        service {
          name = "opentracing-example"
          port = "http"

          connect {
            sidecar_service {
            }
            sidecar_task {
                name  = "connect-opentracing"
                driver = "exec"
                config {
                    command = "/usr/bin/envoy"
                    args  = [
                        "-c",
                        "${NOMAD_SECRETS_DIR}/envoy_bootstrap.json",
                        "-l",
                        "${meta.connect.log_level}"
                    ]
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
        task "springboot" {
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
                    service-name: AppA
                    enabled: TRUE
                    udp-sender:
                      host: jaeger-agent.service.hcpoc.consul
                      port: 6831
              EOT
              destination = "local/application.yml"
            }
            env {
              SERVER_PORT="${NOMAD_PORT_http}"
              MANAGEMENT_SERVER_PORT="${NOMAD_PORT_http_mgmt}"
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
                source = "https://objectstorage.eu-frankfurt-1.oraclecloud.com/p/UeiLjAem614XkVV12OhbbflBbO66nu81DQG7aFpZ56k/n/bancamediolanum3y/b/artifacts/o/OpenTracing-AppA-0.0.1-SNAPSHOT.jar",
                destination = "local/"
            }
        }
    }
}