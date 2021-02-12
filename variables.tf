variable "dc_names" {
  type = list(string)
}
variable "domain" {
  type = string
}
variable "services_domain" {
  type = string
}
variable "container_registry" {
  type    = string
  default = "us.gcr.io/hcpoc-terraform-admin"
}
variable "artifacts_source_prefix" {
  type = string
}
variable "logstash_index_prefix" {
  type    = string
  default = "logs-"
}
variable "nomad_endpoint" {
  type        = string
  description = "(required) nomad cluster endpoint"
}
variable "vault_endpoint" {
  type    = string
  default = null
}
variable "consul_endpoint" {
  type    = string
  default = null
}
variable "vault_skip_tls_verify" {
  type    = bool
  default = false
}
variable "consul_insecure_https" {
  type    = bool
  default = false
}
variable "cloud" {
  type        = string
  default     = ""
  description = "Allow to deploy cloud specific jobs"
  validation {
    condition     = contains(toset(["gcp", "aws", ""]), var.cloud)
    error_message = "Unsupported cloud configured."
  }
}
variable "jenkins_volume_external_id" {
  // GCP example: projects/${var.gcp_project_id}/regions/${var.gcp_region}/disks/jenkins-master
  // AWS example: vol-abc123abc123
  type    = string
  default = ""
}
variable "nameserver_dummy_ip" {
  type    = string
  default = "192.168.0.1"
}

variable "ca_cert_file" {
  type    = string
  default = null
}

variable "configure_grafana" {
  type    = bool
  default = true
}

variable "configure_monitoring" {
  type    = bool
  default = true
}

variable "configure_openfaas" {
  type    = bool
  default = true
}


variable "worker_jobs_constraint" {
  type = list(map(string))
  default = [{
    attribute = "$${meta.nodeType}"
    operator  = "="
    value     = "worker"
  }]
  description = "List of constraints to be applied to jobs running in workers. Escape $ with double $."
}

variable "monitoring_jobs_constraint" {
  type = list(map(string))
  default = [{
    attribute = "$${meta.nodeType}"
    operator  = "="
    value     = "monitoring"
  }]
  description = "List of constraints to be applied to jobs running in monitoring node. Escape $ with double $."
}
