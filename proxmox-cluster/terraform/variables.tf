# Variables
variable "proxmox_password" {
  description = "Proxmox password for terraform user"
  type        = string
  sensitive   = true
}

variable "proxmox_endpoint" {
  description = "Proxmox endpoint URL"
  type        = string
  default     = "https://<PVE1_IP>:8006/"
}

variable "proxmox_username" {
  description = "Proxmox username"
  type        = string
  default     = "root@pam"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/laptop_id_rsa.pub"
}

variable "nodes" {
  description = "List of Proxmox nodes"
  type        = list(string)
  default     = ["pve1", "pve2", "pve3"]
}

variable "ubuntu_image_url" {
  description = "URL for Ubuntu cloud image"
  type        = string
  default     = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

variable "debian_template" {
  description = "Debian template for LXC containers"
  type        = string
  default     = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
}
