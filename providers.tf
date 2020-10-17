terraform {
  required_version = "~> 0.12.28"
}

provider "vault" {
  address         = var.vault_endpoint
  skip_tls_verify = var.vault_skip_tls_verify
}

data "vault_generic_secret" "consul_bootstrap_token" {
  path = "secret/consul/bootstrap_token"
}

provider "consul" {
  address        = var.consul_endpoint
  insecure_https = false
  scheme         = "https"
  token          = data.vault_generic_secret.consul_bootstrap_token.data["secretid"]
}

provider "grafana" {
  url  = "https://grafana-internal.${var.domain}"
  auth = "admin:admin"
}


provider "nomad" {
  address = var.nomad_endpoint
  region  = "global"
}
