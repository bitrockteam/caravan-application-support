job "consul-esm" {
  datacenters = [
    %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
  ]
  constraint {
    attribute = "$${meta.nodeType}"
    operator  = "="
    value     = "worker"
  }
  group "esm-group" {
    network {
      mode = "host"
    }
    task "esm" {
      driver = "exec"
      user   = "root"
      template {
        destination = "secrets/env"
        env = true
        data = "CONSUL_HTTP_TOKEN={{ with secret \"consul/creds/consul-esm-role\" }}{{ .Data.token }}{{ end }}"
      }
      config {
        command = "/usr/local/bin/consul-esm"
      }
    }
  }
}
