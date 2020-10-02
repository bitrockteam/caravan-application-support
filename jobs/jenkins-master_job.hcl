job "jenkins" {
    datacenters = [
        %{ for dc_name in dc_names ~}"${dc_name}",%{ endfor ~}
    ]

  type        = "service"
  priority    = 50

  update {
    stagger      = "10s"
    max_parallel = 1
  }

  group "jenkins-master" {
    count = 1

    volume "jenkins-master" {
      type      = "csi"
      read_only = false
      source    = "jenkins-master"
    }


    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "jenkins-master" {
      driver = "docker"

      volume_mount {
        volume      = "jenkins-master"
        destination = "/var/jenkins_home"
        read_only   = false
      }

      config {
        image = "jenkins/jenkins:lts"

        port_map {
          http = 8080
          jnlp = 50000
        }

        dns_servers = ["$${attr.unique.network.ip-address}"]        
      }

      service {
        name = "jenkins-master"
        tags = ["global", "jenkins", "master"]
        port = "http"

        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }

      resources {
        cpu    = 500
        memory = 768

        network {
          mbits = 10

          port "http" {
            static = 8080
          }

          port "jnlp" {
            static = 50000
          }
        }
      }

      logs {
        max_files     = 10
        max_file_size = 15
      }

      kill_timeout = "20s"
    }
  }
}
