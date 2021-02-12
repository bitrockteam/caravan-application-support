job "csi_nodes" {
    datacenters = [
        %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]
  type = "system"
  group "nodes" {
    task "plugin" {
      driver = "docker"
      template {
        change_mode = "noop"
        destination = "/secrets/azure.json"
        data = <<EOH
{{ with secret "azure/creds/contributor" }}
{
"cloud":"${azure_cloud}",
"tenantId": "${azure_tenant_id}",
"subscriptionId": "${azure_subscription_id}",
"aadClientId": "{{ .Data.client_id }}",
"aadClientSecret": "{{ .Data.client_secret }}",
"resourceGroup": "$${attr.platform.azure.resource-group}",
"location": "$${{attr.platform.azure.location}}"
}
{{ end }}
EOH
      }
      env {
        AZURE_CREDENTIAL_FILE = "/secrets/azure.json"
      }
      config {
        image = "mcr.microsoft.com/k8s/csi/azuredisk-csi"
        args = [
          "--nodeid=$${attr.unique.hostname}",
          "--endpoint=unix:///csi/csi.sock",
          "--logtostderr",
          "--v=5",
        ],
        dns_servers = ["$${attr.unique.network.ip-address}"]
        privileged = true
      }
      csi_plugin {
        id        = "${ plugin_id }"
        type      = "node"
        mount_dir = "/csi"
      }
      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
