terraform {
  required_providers {
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "~> 1.0"
    }
    nomad = {
      source  = "hashicorp/nomad"
      version = "~> 1.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.0"
    }
  }
  required_version = "~> 0.15"
}
