# 🏠 Homelab 2.0

My over-engineered home network that probably went too far, but here we are.

## What is this?

Enterprise-grade networking at home because I got tired of my ISP's router and things spiraled from there. VLANs, high availability clusters, hybrid cloud — the works.

<table>
<tr>
<td align="center">
  <a href="https://grafana.coventix.be/public-dashboards/9c317975a88a4d93ac518a766fde8ec9">
    <img src="./images/grafana-preview.jpg" width="400px" alt="Grafana"/>
    <br/>📊 Live Stats
  </a>
</td>
<td align="center">
  <a href="https://uptime.coventix.be/status/acacia">
    <img src="./images/uptime-preview.jpg" width="400px" alt="Uptime"/>
    <br/>⚡ Uptime Monitor
  </a>
</td>
</tr>
</table>

## The Setup

**MikroTik Router** — Handles VLANs, WireGuard VPN, and keeps everything locked down  
**TP-Link Switch & AP** — VLAN support across wired and wireless  
**Raspberry Pi** — Running DNS, monitoring, and reverse proxy  
**Proxmox Cluster** — 3 nodes for high availability, all managed with Terraform  
**Oracle Cloud** — 2 free tier instances connected via WireGuard tunnel  
**Storage** — SMB file shares and automated backups

## 🗺️ Network Diagram

![diagram](./network-diagram.jpg)
*The whole shebang*

## Why though?

**Security** — Separate VLANs for different device types. IoT devices can't see my main network, guests get their own isolated WiFi, servers are locked down. Default deny firewall rules for everything.

**High Availability** — The Proxmox cluster runs 2 nginx containers on different nodes with a HAProxy load balancer on a third. If a node dies, services keep running.

**Cloud Integration** — Oracle Cloud instances are connected via WireGuard, basically extending the homelab. Useful for external monitoring and testing cloud stuff.

**Self-Hosted Everything** — AdGuard Home for DNS, Advanced monitoring (Grafana, Prometheus, Uptimekuma, MKTXP, ...), Caddy for reverse proxy, Code-server for editing configs from anywhere.

**Infrastructure as Code** — The entire Proxmox setup is managed with Terraform. No clicking through UIs, everything's version controlled.

## ✨ Cool Stuff

**mDNS bridging** — IoT devices can still cast to TVs even though they're on different VLANs.

**VLAN-tagged WiFi** — One access point, multiple isolated wireless networks. Each WiFi network maps to its own VLAN.

**SSHFS home directories** — Code-server mounts my home directory from everywhere, so I can edit any config file from a browser.

**Automated backups** — Router configs get backed up to an SFTP server automatically. Because losing config is the worst.

## 🌐 Network Breakdown

- **VLAN 10** — Main LAN, full access
- **VLAN 20** — Servers, restricted and monitored  
- **VLAN 30** — IoT devices, internet + mDNS only
- **VLAN 40** — Guest network, completely isolated
- **VLAN 99** — Management, admin access only

---

That's it. It's probably overkill but it works and I learned a ton building it. 🚀
