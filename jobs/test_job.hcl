job "hello_world" {
  datacenters = ["hcpoc"]
  constraint {
    attribute = "${attr.unique.hostname}"
    operator  = "regexp"
    value     = "^defwrkr-"
  }
  type        = "batch"
  group "test" {
    task "hello_world" {
      driver = "raw_exec"
      config {
        command = "/bin/echo"
        args    = ["Hello world from ${node.unique.name}!"]
      }
    }
  }
}