job "poc_esm" {
  datacenters = ["hcpoc"]
  constraint {
    attribute = "${attr.unique.hostname}"
    operator  = "regexp"
    value     = "-pool-def-wrkr-grp$"
  }
  group "esm_group" {
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
