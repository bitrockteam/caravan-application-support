resource "consul_config_entry" "proxy_defaults" {
  kind = "proxy-defaults"
  name = "global"

  config_json = jsonencode({
    Config = {
      protocol                         = "http",
      envoy_prometheus_bind_addr       = "0.0.0.0:9102",
      envoy_extra_static_clusters_json = <<EOL
{
  "connect_timeout": "3.000s",
  "dns_lookup_family": "V4_ONLY",
  "lb_policy": "ROUND_ROBIN",
  "load_assignment": {
      "cluster_name": "jaeger_9411",
      "endpoints": [
          {
              "lb_endpoints": [
                  {
                      "endpoint": {
                          "address": {
                              "socket_address": {
                                  "address": "10.128.0.8",
                                  "port_value": 9411,
                                  "protocol": "TCP"
                              }
                          }
                      }
                  }
              ]
          }
      ]
  },
  "name": "jaeger_9411",
  "type": "STRICT_DNS"
}
EOL
      envoy_tracing_json               = <<EOL
{
  "http": {
      "typed_config": {
          "@type": "type.googleapis.com/envoy.config.trace.v2.ZipkinConfig",
          "collector_cluster": "jaeger_9411",
          "collector_endpoint": "/api/v2/spans",
          "shared_span_context": false,
          "collector_endpoint_version": "HTTP_JSON"
      },
      "name": "envoy.tracers.zipkin"
  }
}
EOL
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
