variable "dc_names" {
  type = list(string)
}
variable "external_domain" {
  type = string
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
variable "ca_cert_file" {
  default = null
}

variable "cloud" {
  type        = string
  default     = ""
  description = "Allow to deploy cloud specific jobs"
}
