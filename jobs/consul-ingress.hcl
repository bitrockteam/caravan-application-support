job "consul-ingress" {
  datacenters = [
    %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
  ]
  %{ for constraint in worker_jobs_constraint ~}
  constraint {
    %{ for key, value in constraint ~}
    "${key}" = "${value}"
    %{ endfor ~}
  }
  %{ endfor ~}
  group "ingress-group" {
    network {
      mode = "bridge"
      port "http" {
        static = 8080
      }
      dns {
        servers = [
          "${nameserver_dummy_ip}"]
      }
    }
    service {
      name = "ingress-gateway"
      tags = [ "ingress", "gateway"]
      port = "http",
      check {
        type = "tcp"
        port = "http"
        interval = "5s"
        timeout = "2s"
      }
      connect {
        gateway {
          proxy {}
          ingress {
            listener {
              port = 8080
              protocol = "http"
              %{ for service in ingress_services ~}
              service {
                name = "${service["name"]}"
                hosts = [ "${service["host"]}.${domain}" ]
              }
              %{ endfor ~}
            }
          }
        }
      }
    }
  }
}
