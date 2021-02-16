terraform {
  required_providers {
    consul = {
      source = "hashicorp/consul"
    }
    grafana = {
      source = "grafana/grafana"
    }
    nomad = {
      source = "hashicorp/nomad"
    }
    vault = {
      source = "hashicorp/vault"
    }
  }
  required_version = "~> 0.13.6"
}
