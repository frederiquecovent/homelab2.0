# Local values and configuration

# VMs configuration
locals {
  vms = {
    "monitoring" = {
      node      = "pve1"
      vm_id     = 100
      cores     = 2
      memory    = 8192
      disk_size = 50
    }
    "nginx1" = {
      node      = "pve2"
      vm_id     = 101
      cores     = 2
      memory    = 4096
      disk_size = 15
    }
    "nginx2" = {
      node      = "pve3"
      vm_id     = 102
      cores     = 2
      memory    = 4096
      disk_size = 15
    }
    "loadbalancer" = {
      node      = "pve1"
      vm_id     = 103
      cores     = 2
      memory    = 4096
      disk_size = 15
    }
  }

  # LXC containers configuration
  lxcs = {
    "sftp" = {
      node       = "pve2"
      vm_id      = 200
      cores      = 2
      memory     = 1024
      disk_size  = 30
      privileged = false
    }
    "portainer" = {
      node       = "pve1"
      vm_id      = 201
      cores      = 2
      memory     = 1024
      disk_size  = 15
      privileged = true
    }
    "smb" = {
      node       = "pve3"
      vm_id      = 202
      cores      = 2
      memory     = 2048
      disk_size  = 100
      privileged = true
    }
  }
}