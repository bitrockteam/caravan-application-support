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
}
variable "jenkins_volume_external_id" {
  // example: projects/${var.gcp_project_id}/regions/${var.gcp_region}/disks/jenkins-master
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
