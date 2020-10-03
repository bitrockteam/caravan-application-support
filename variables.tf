variable "dc_names" {
  type = list(string)
}
variable "external_domain" {
  type = string
}
variable "subdomain" {
  type = string
}
variable "services_domain" {
  type = string
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
variable "cloud" {
  type        = string
  default     = ""
  description = "Allow to deploy cloud specific jobs"
}
