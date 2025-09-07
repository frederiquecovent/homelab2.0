# Image Downloads and Cloud Configuration

# Downloads Ubuntu cloud image on each node
resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  for_each     = toset(var.nodes)
  content_type = "iso"
  datastore_id = "local"
  node_name    = each.key
  url          = var.ubuntu_image_url
}

# Per-node cloud-init user-data (snippets live on the node's local storage)
resource "proxmox_virtual_environment_file" "cloud_config" {
  for_each     = toset(var.nodes)
  content_type = "snippets"
  datastore_id = "local"
  node_name    = each.key

  source_raw {
    data = <<EOF
#cloud-config
package_update: true
users:
  - default
  - name: ubuntu
    groups: [sudo]
    shell: /bin/bash
    ssh_authorized_keys:
      - ${trimspace(file(var.ssh_public_key_path))}
    sudo: ALL=(ALL) NOPASSWD:ALL
packages:
  - qemu-guest-agent
runcmd:
  - systemctl enable --now qemu-guest-agent
EOF
    file_name = "cloud-config.yaml"
  }
}
