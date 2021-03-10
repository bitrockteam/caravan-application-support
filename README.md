# Caravan Application Support

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14 |

## Providers

| Name | Version |
|------|---------|
| consul | n/a |
| grafana | n/a |
| nomad | n/a |
| vault | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| kibana | git::ssh://git@github.com/bitrockteam/caravan-cart//modules/kibana?ref=main |  |

## Resources

| Name |
|------|
| [consul_config_entry](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/config_entry) |
| [grafana_dashboard](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/dashboard) |
| [grafana_data_source](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/data_source) |
| [nomad_job](https://registry.terraform.io/providers/hashicorp/nomad/latest/docs/resources/job) |
| [nomad_plugin](https://registry.terraform.io/providers/hashicorp/nomad/latest/docs/data-sources/plugin) |
| [nomad_volume](https://registry.terraform.io/providers/hashicorp/nomad/latest/docs/resources/volume) |
| [vault_generic_secret](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| artifacts\_source\_prefix | n/a | `string` | n/a | yes |
| dc\_names | n/a | `list(string)` | n/a | yes |
| domain | n/a | `string` | n/a | yes |
| nomad\_endpoint | (required) nomad cluster endpoint | `string` | n/a | yes |
| services\_domain | n/a | `string` | n/a | yes |
| azure\_cloud\_environment | n/a | `string` | `"AzurePublicCloud"` | no |
| azure\_subscription\_id | n/a | `string` | `""` | no |
| azure\_tenant\_id | n/a | `string` | `""` | no |
| ca\_cert\_file | n/a | `string` | `null` | no |
| cloud | Allow to deploy cloud specific jobs | `string` | `""` | no |
| configure\_grafana | n/a | `bool` | `true` | no |
| configure\_monitoring | n/a | `bool` | `true` | no |
| consul\_endpoint | n/a | `string` | `null` | no |
| consul\_insecure\_https | n/a | `bool` | `false` | no |
| container\_registry | n/a | `string` | `"docker.io"` | no |
| ingress\_services | n/a | `list(map(string))` | <pre>[<br>  {<br>    "host": "jaeger",<br>    "name": "jaeger-query"<br>  },<br>  {<br>    "host": "grafana",<br>    "name": "grafana-internal"<br>  },<br>  {<br>    "host": "kibana",<br>    "name": "kibana"<br>  },<br>  {<br>    "host": "prometheus",<br>    "name": "prometheus"<br>  }<br>]</pre> | no |
| jenkins\_volume\_external\_id | n/a | `string` | `""` | no |
| logstash\_index\_prefix | n/a | `string` | `"logs-"` | no |
| monitoring\_jobs\_constraint | List of constraints to be applied to jobs running in monitoring node. Escape $ with double $. | `list(map(string))` | <pre>[<br>  {<br>    "attribute": "${meta.nodeType}",<br>    "operator": "=",<br>    "value": "monitoring"<br>  }<br>]</pre> | no |
| nameserver\_dummy\_ip | n/a | `string` | `"192.168.0.1"` | no |
| terminating\_services | n/a | `list(map(string))` | <pre>[<br>  {<br>    "name": "logstash-tcp"<br>  },<br>  {<br>    "name": "logstash-http"<br>  },<br>  {<br>    "name": "jaeger-query"<br>  },<br>  {<br>    "name": "grafana-internal"<br>  },<br>  {<br>    "name": "elastic-internal"<br>  },<br>  {<br>    "name": "prometheus"<br>  }<br>]</pre> | no |
| vault\_endpoint | n/a | `string` | `null` | no |
| vault\_skip\_tls\_verify | n/a | `bool` | `false` | no |
| worker\_jobs\_constraint | List of constraints to be applied to jobs running in workers. Escape $ with double $. | `list(map(string))` | <pre>[<br>  {<br>    "attribute": "${meta.nodeType}",<br>    "operator": "=",<br>    "value": "worker"<br>  }<br>]</pre> | no |

## Outputs

No output.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
