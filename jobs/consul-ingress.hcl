job "consul-ingress" {
  datacenters = ["hcpoc"]
  constraint {
    attribute = "${attr.unique.hostname}"
    operator  = "regexp"
    value     = "^defwrkr-"
  }
  group "ingress-group" {
    network {
      port "http" {
        static = 8181
        to     = 8181
      }
      mode = "host"
    }
    task "ingress" {
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
          "-gateway=ingress",
          "-register",
          "-service", "ingress-gateway",
          "-address", "${NOMAD_IP_http}:8181",
          "-http-addr", "http://127.0.0.1:8501",
          "-ca-file", "/etc/consul.d/ca",
          "-client-cert", "/etc/consul.d/cert",
          "-client-key", "/etc/consul.d/keyfile"
        ]
      }
    }
  }
}
