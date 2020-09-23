job "echo_job" {
    datacenters = ["hcpoc"]
    constraint {
      attribute = "${attr.unique.hostname}"
      operator  = "regexp"
      value     = "^defwrkr-"
    }
    group "echo_group" {
        network {
            mode = "bridge"
            port "http" {
            }
        }

        service {
          name = "spring-echo-example"
          port = "http"

          connect {
            sidecar_service {
              proxy {
                upstreams {
                  destination_name = "logstash-tcp"
                  local_bind_port  = 4560
                }
                upstreams {
                  destination_name = "logstash-http"
                  local_bind_port  = 4561
                }
                upstreams {
                  destination_name = "elastic-internal"
                  local_bind_port  = 9200
                }
              }
            }
            sidecar_task {
                name  = "connect-spring-echo-example"
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
                memory = 512
            }
            template {
              data = "nameserver {{env `NOMAD_HOST_IP_http`}}"
              destination = "etc/resolv.conf"
            }
            config {
                command = "/bin/java"
                args =  [ "-Xmx2048m", "-Xms256m", "-jar", "local/spring-echo-example-1.0.0.jar", "--server.port=${NOMAD_PORT_http}"]
            }

            artifact {
                source = "gcs::https://www.googleapis.com/storage/v1/cfgs-bmed-1181724079/spring-echo-example-1.0.0.jar",
                destination = "local/"
            }
        }
    }
}