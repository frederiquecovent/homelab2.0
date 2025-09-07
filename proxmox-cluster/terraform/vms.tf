# Virtual Machines

# Create VMs from the Ubuntu cloud image on the correct node
resource "proxmox_virtual_environment_vm" "vms" {
  for_each  = local.vms
  
  name      = each.key
  node_name = each.value.node
  vm_id     = each.value.vm_id
  started   = true

  cpu {
    cores = each.value.cores
  }

  memory {
    dedicated = each.value.memory
  }

  agent {
    enabled = true
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image[each.value.node].id
    interface    = "virtio0"
    size         = each.value.disk_size
  }

  initialization {
    ip_config {
      ipv4 { address = "dhcp" }
    }
    user_data_file_id = proxmox_virtual_environment_file.cloud_config[each.value.node].id
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  # Helpful for cloud images
  boot_order = ["virtio0"]
}
