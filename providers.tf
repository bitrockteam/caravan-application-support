provider "vault" {
  address         = var.vault_endpoint
  skip_tls_verify = var.vault_skip_tls_verify
  ca_cert_file    = var.ca_cert_file
}

data "vault_generic_secret" "consul_bootstrap_token" {
  path = "secret/consul/bootstrap_token"
}

provider "consul" {
  address        = var.consul_endpoint
  insecure_https = var.consul_insecure_https
  ca_file        = var.ca_cert_file
  scheme         = "https"
  token          = data.vault_generic_secret.consul_bootstrap_token.data["secretid"]
}

provider "nomad" {
  address = var.nomad_endpoint
  region  = "global"
  ca_file = var.ca_cert_file
}

provider "grafana" {
  url  = "https://grafana-internal.${var.domain}"
  auth = "admin:admin"
}
