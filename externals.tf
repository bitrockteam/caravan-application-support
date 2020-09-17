# resource "consul_node" "devops-proxy" {
#   address = "172.23.2.11"
#   name    = "devops-proxy"
#   meta = {
#     external-node  = true
#     external-probe = true
#   }
# }
# resource "consul_service" "devops-proxy-http" {
#   name = "${consul_node.devops-proxy.name}-http"
#   node = consul_node.devops-proxy.name
#   port = 8080
#   meta = {
#     external-source = "terraform"
#   }

#   check {
#     check_id                          = "service:devops-proxy-http"
#     name                              = "HTTP health check"
#     status                            = "passing"
#     tls_skip_verify                   = true
#     http                              = "http://172.23.2.11:8080/noindex/css/bootstrap.min.css"
#     interval                          = "15s"
#     timeout                           = "3s"
#     deregister_critical_service_after = "30s"
#   }
# }
