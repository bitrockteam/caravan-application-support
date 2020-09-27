job "consul-terminating" {
  datacenters = ["hcpoc"]
  constraint {
    attribute = "${attr.unique.hostname}"
    operator  = "regexp"
    value     = "^defwrkr-"
  }
  group "terminating-group" {
    network {
      mode = "host"
      port "envoy_admin" {}
      port "http" {
        static = 21101
      }
    }
    task "terminating" {
      driver = "exec"
      user   = "consul"
      env {
        CONSUL_HTTP_SSL = "true"
      }
      template {
        destination = "secrets/env"
        env = true
        data = "CONSUL_HTTP_TOKEN={{ with secret \"consul/creds/consul-agent-role\" }}{{ .Data.token }}{{ end }}"
      }
      config {
        command = "/usr/local/bin/consul"
        args = [
          "connect", "envoy",
          "-envoy-binary", "/usr/bin/envoy",
          "-gateway=terminating",
          "-register",
          "-service", "poc-terminating",
          "-admin-bind", "127.0.0.1:${NOMAD_PORT_envoy_admin}",
          "-address", "${NOMAD_ADDR_http}",
          "-http-addr", "http://127.0.0.1:8501",
          "-ca-file", "/etc/consul.d/ca",
          "-client-cert", "/etc/consul.d/cert",
          "-client-key", "/etc/consul.d/keyfile"
        ]
      }
    }
  }
}
