variable "datacenters" {
  type = list(string)
}

variable "dns_servers" {
  type = list(string)
}

variable "terminating_services" {
  type = list(map(string))
}

job "consul-terminating" {
  datacenters = var.datacenters

  group "terminating-group" {
    network {
      mode = "host"
      port "http" {
        static = 21101
        to     = 8080
      }
      dns {
        servers = var.dns_servers
      }
    }
    service {
      name = "terminating-gateway"
      tags = [
        "terminating",
        "gateway"]
      port = "http"
      check {
        type = "tcp"
        port = "http"
        interval = "5s"
        timeout = "2s"
      }
      connect {
        gateway {
          proxy {}
          terminating {

            dynamic "service" {
              for_each = var.terminating_services
              content {
                name = service.value["name"]
              }
            }
          }
        }
      }
    }
  }
}

