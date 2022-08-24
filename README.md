# Caravan Application Support

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_consul"></a> [consul](#requirement\_consul) | ~> 2.0 |
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | ~> 1.0 |
| <a name="requirement_nomad"></a> [nomad](#requirement\_nomad) | ~> 1.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_consul"></a> [consul](#provider\_consul) | 2.12.0 |
| <a name="provider_grafana"></a> [grafana](#provider\_grafana) | 1.13.2 |
| <a name="provider_nomad"></a> [nomad](#provider\_nomad) | 1.4.15 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 2.22.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_filebeat"></a> [filebeat](#module\_filebeat) | git::https://github.com/bitrockteam/caravan-cart//modules/filebeat | refs/tags/v0.3.7 |
| <a name="module_jaeger"></a> [jaeger](#module\_jaeger) | git::https://github.com/bitrockteam/caravan-cart//modules/jaeger | refs/tags/v0.4.5 |
| <a name="module_kibana"></a> [kibana](#module\_kibana) | git::https://github.com/bitrockteam/caravan-cart//modules/kibana | refs/tags/v0.4.12 |
| <a name="module_logstash"></a> [logstash](#module\_logstash) | git::https://github.com/bitrockteam/caravan-cart//modules/logstash | refs/tags/v0.3.7 |

## Resources

| Name | Type |
|------|------|
| [consul_config_entry.elastic_internal](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.grafana_internal](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.ingress_gateway](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.jaeger_agent](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.jaeger_collector](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.jaeger_query](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.kibana](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.logstash-http](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.logstash-tcp](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.logstash-tcp-service-defaults](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.prometheus](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.proxy_defaults](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.star](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [consul_config_entry.terminating_gateway](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) | resource |
| [grafana_dashboard.dashboard](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/dashboard) | resource |
| [grafana_data_source.metrics](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/data_source) | resource |
| [nomad_job.consul-esm](https://registry.terraform.io/providers/hashicorp/nomad/latest/docs/resources/job) | resource |
| [nomad_job.consul-ingress](https://registry.terraform.io/providers/hashicorp/nomad/latest/docs/resources/job) | resource |
| [nomad_job.consul-terminating](https://registry.terraform.io/providers/hashicorp/nomad/latest/docs/resources/job) | resource |
| [nomad_job.csi](https://registry.terraform.io/providers/hashicorp/nomad/latest/docs/resources/job) | resource |
| [nomad_volume.jenkins_master](https://registry.terraform.io/providers/hashicorp/nomad/latest/docs/resources/volume) | resource |
| [null_resource.grafana_healthy](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [nomad_plugin.csi](https://registry.terraform.io/providers/hashicorp/nomad/latest/docs/data-sources/plugin) | data source |
| [vault_generic_secret.consul_bootstrap_token](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifacts_source_prefix"></a> [artifacts\_source\_prefix](#input\_artifacts\_source\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_dc_names"></a> [dc\_names](#input\_dc\_names) | n/a | `list(string)` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_nomad_endpoint"></a> [nomad\_endpoint](#input\_nomad\_endpoint) | (required) nomad cluster endpoint | `string` | n/a | yes |
| <a name="input_services_domain"></a> [services\_domain](#input\_services\_domain) | n/a | `string` | n/a | yes |
| <a name="input_azure_cloud_environment"></a> [azure\_cloud\_environment](#input\_azure\_cloud\_environment) | n/a | `string` | `"AzurePublicCloud"` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | n/a | `string` | `""` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | n/a | `string` | `""` | no |
| <a name="input_ca_cert_file"></a> [ca\_cert\_file](#input\_ca\_cert\_file) | n/a | `string` | `null` | no |
| <a name="input_cloud"></a> [cloud](#input\_cloud) | Allow to deploy cloud specific jobs | `string` | `""` | no |
| <a name="input_configure_grafana"></a> [configure\_grafana](#input\_configure\_grafana) | n/a | `bool` | `true` | no |
| <a name="input_configure_monitoring"></a> [configure\_monitoring](#input\_configure\_monitoring) | n/a | `bool` | `true` | no |
| <a name="input_consul_endpoint"></a> [consul\_endpoint](#input\_consul\_endpoint) | n/a | `string` | `null` | no |
| <a name="input_consul_insecure_https"></a> [consul\_insecure\_https](#input\_consul\_insecure\_https) | n/a | `bool` | `false` | no |
| <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry) | n/a | `string` | `"docker.io"` | no |
| <a name="input_ingress_services"></a> [ingress\_services](#input\_ingress\_services) | n/a | `list(map(string))` | <pre>[<br>  {<br>    "host": "jaeger",<br>    "name": "jaeger-query"<br>  },<br>  {<br>    "host": "grafana",<br>    "name": "grafana-internal"<br>  },<br>  {<br>    "host": "kibana",<br>    "name": "kibana"<br>  },<br>  {<br>    "host": "prometheus",<br>    "name": "prometheus"<br>  }<br>]</pre> | no |
| <a name="input_jenkins_volume_external_id"></a> [jenkins\_volume\_external\_id](#input\_jenkins\_volume\_external\_id) | n/a | `string` | `""` | no |
| <a name="input_logstash_index_prefix"></a> [logstash\_index\_prefix](#input\_logstash\_index\_prefix) | n/a | `string` | `"logs-"` | no |
| <a name="input_monitoring_jobs_constraint"></a> [monitoring\_jobs\_constraint](#input\_monitoring\_jobs\_constraint) | List of constraints to be applied to jobs running in monitoring node. Escape $ with double $. | `list(map(string))` | <pre>[<br>  {<br>    "attribute": "${meta.nodeType}",<br>    "operator": "=",<br>    "value": "monitoring"<br>  }<br>]</pre> | no |
| <a name="input_nameserver_dummy_ip"></a> [nameserver\_dummy\_ip](#input\_nameserver\_dummy\_ip) | n/a | `string` | `"192.168.0.1"` | no |
| <a name="input_terminating_services"></a> [terminating\_services](#input\_terminating\_services) | n/a | `list(map(string))` | <pre>[<br>  {<br>    "name": "logstash-tcp"<br>  },<br>  {<br>    "name": "logstash-http"<br>  },<br>  {<br>    "name": "jaeger-query"<br>  },<br>  {<br>    "name": "grafana-internal"<br>  },<br>  {<br>    "name": "elastic-internal"<br>  },<br>  {<br>    "name": "prometheus"<br>  }<br>]</pre> | no |
| <a name="input_vault_endpoint"></a> [vault\_endpoint](#input\_vault\_endpoint) | n/a | `string` | `null` | no |
| <a name="input_vault_skip_tls_verify"></a> [vault\_skip\_tls\_verify](#input\_vault\_skip\_tls\_verify) | n/a | `bool` | `false` | no |
| <a name="input_worker_jobs_constraint"></a> [worker\_jobs\_constraint](#input\_worker\_jobs\_constraint) | List of constraints to be applied to jobs running in workers. Escape $ with double $. | `list(map(string))` | <pre>[<br>  {<br>    "attribute": "${meta.nodeType}",<br>    "operator": "=",<br>    "value": "worker"<br>  }<br>]</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
