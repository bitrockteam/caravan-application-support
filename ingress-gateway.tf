# workaround for deleting ingress-gateway config generated from nomad job on destroy
resource "consul_config_entry" "ingress_gateway" {
  name = "ingress-gateway"
  kind = "ingress-gateway"

  config_json = jsonencode({})

  lifecycle {
    ignore_changes = [
      config_json
    ]
  }

  depends_on = [consul_config_entry.proxy_defaults]
}
