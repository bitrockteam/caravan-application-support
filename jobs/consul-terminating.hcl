job "consul-terminating" {
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
  group "terminating-group" {
    network {
      mode = "bridge"
      dns {
        servers = [
          "${nameserver_dummy_ip}"]
      }
    }
    service {
      name = "terminating-gateway"
      tags = [
        "terminating",
        "gateway"]
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
          terminating {
              %{for srv in terminating_services ~}
              service {
                %{ for key, value in srv ~}
                ${key} = "${value}"
                %{ endfor ~}
              }
              %{ endfor ~}
          }
        }
      }
    }
  }
}
