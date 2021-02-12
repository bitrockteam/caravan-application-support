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
          "-envoy-version", "1.14.2",
          "-gateway=ingress",
          "-register",
          "-service", "ingress-gateway",
          "-address", "$${NOMAD_IP_http}:8181",
          "-http-addr", "http://127.0.0.1:8501",
          "-ca-file", "/etc/consul.d/ca",
          "-client-cert", "/etc/consul.d/cert",
          "-client-key", "/etc/consul.d/keyfile"
        ]
      }
    }
  }
}
