# workaround for deleting terminating-gateway config generated from nomad job on destroy
resource "consul_config_entry" "terminating_gateway" {
  name = "terminating-gateway"
  kind = "terminating-gateway"

  config_json = jsonencode({})

  lifecycle {
    ignore_changes = [
      config_json
    ]
  }

  depends_on = [consul_config_entry.proxy_defaults]
}
