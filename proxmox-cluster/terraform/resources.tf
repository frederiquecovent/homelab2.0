# Local values and configuration

# VMs configuration
locals {
  vms = {
    "web-server" = {
      node      = "pve1"
      vm_id     = 100
      cores     = 2
      memory    = 2048
      disk_size = 20
    }
    "db-server" = {
      node      = "pve2"
      vm_id     = 101
      cores     = 4
      memory    = 4096
      disk_size = 50
    }
  }

  # LXC containers configuration
  lxcs = {
    "docker-host" = {
      node       = "pve3"
      vm_id      = 200
      cores      = 2
      memory     = 1024
      disk_size  = 30
      privileged = true
    }
    "monitoring" = {
      node       = "pve1"
      vm_id      = 201
      cores      = 1
      memory     = 512
      disk_size  = 10
      privileged = false
    }
  }
}
