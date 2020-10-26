resource "consul_config_entry" "proxy_defaults" {
  kind = "proxy-defaults"
  name = "global"

  config_json = jsonencode({
    Config = {
      protocol                         = "http",
      envoy_prometheus_bind_addr       = "0.0.0.0:9102"
      envoy_extra_static_clusters_json = file("envoy_configs/envoy_extra_static_clusters.json")
      envoy_tracing_json               = file("envoy_configs/envoy_tracing.json")
    }
  })
}
