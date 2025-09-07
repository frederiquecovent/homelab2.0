# LXC Containers

# Create LXC containers from the Debian template on the correct node
resource "proxmox_virtual_environment_container" "lxcs" {
  for_each = local.lxcs

  node_name = each.value.node
  vm_id     = each.value.vm_id
  started   = true

  initialization {
    hostname = each.key

    ip_config {
      ipv4 { address = "dhcp" }
    }

    user_account {
      keys = [trimspace(file(var.ssh_public_key_path))]
      # password intentionally omitted (SSH keys only)
    }
  }

  cpu {
    cores = each.value.cores
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = "local-lvm"
    size         = each.value.disk_size
  }

  network_interface {
    name = "eth0"
  }

  operating_system {
    template_file_id = var.debian_template
    type             = "debian"
  }

  # Enable features broadly; keeps Docker happier even if privileged=false
  features {
    nesting = true
    keyctl  = true
    fuse    = true
  }

  unprivileged = !each.value.privileged
}
