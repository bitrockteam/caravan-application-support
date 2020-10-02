resource "consul_config_entry" "proxy_defaults" {
  kind = "proxy-defaults"
  name = "global"

  config_json = jsonencode({
    Config = {
      protocol = "http2",
      envoy_prometheus_bind_addr = "0.0.0.0:9102",
      envoy_tracing_json = <<EOF
{
  "http": {
    "name": "envoy.tracers.dynamic_ot",
    "config": {
      "library": "/usr/local/lib/libjaegertracing_plugin.so",
      "config": {
        "sampler" {
          "type": "const"
          "param": 1
        },
        "reporter": {
          "localAgentHostPort": "jaeger.service.consul:6831"
        }
      }
    }
  }
}
EOF
    }
  })
}

resource "consul_config_entry" "logstash-tcp-service-defaults" {
  name = "logstash-tcp"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = "tcp"
  })
}
