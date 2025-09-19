## Firewall Rules (OCI VMs)

Both Oracle Cloud VMs are placed in a private subnet (no public IPs), reachable only via the WireGuard VPN on **VM1 (10.0.0.5)**.  
Firewalling is applied with **iptables-persistent** for extra security

### VM1 — WireGuard Gateway (10.0.0.5)

**Purpose:** Terminates WireGuard, forwards traffic into the OCI subnet, exposes node_exporter for monitoring. Also acts as loadbalancer for custom nginx application (running on VM2 and on VM in homelab)

Ruleset (`/etc/iptables/rules.v4`):

```bash
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]

# Allow loopback
-A INPUT -i lo -j ACCEPT

# Allow established connections
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# WireGuard UDP
-A INPUT -p udp --dport 51821 -j ACCEPT

# SSH from homelab
-A INPUT -s 192.168.0.0/17 -p tcp --dport 22 -j ACCEPT

# Prometheus scrape (node_exporter)
-A INPUT -s <VM_IP>/32 -p tcp --dport 9100 -j ACCEPT

# ICMP echo-request (ping) from homelab
-A INPUT -s 192.168.0.0/17 -p icmp --icmp-type 8 -j ACCEPT

# Forward traffic between WireGuard and OCI subnet
-A FORWARD -i wg0 -o ens3 -j ACCEPT
-A FORWARD -i ens3 -o wg0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

COMMIT
```


### VM2 — Private Node (10.0.0.27)

**Purpose:** Application/monitoring target. Accessible only via WireGuard through VM1. Also allow http, https and icmp from VM1.

Ruleset (`/etc/iptables/rules.v4`):

```bash
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]

# Allow loopback
-A INPUT -i lo -j ACCEPT

# Allow established connections
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# SSH from homelab
-A INPUT -s 192.168.0.0/17 -p tcp --dport 22 -j ACCEPT

# Prometheus scrape (node_exporter)
-A INPUT -s <VM_IP>/32 -p tcp --dport 9100 -j ACCEPT

# ICMP echo-request (ping) from homelab
-A INPUT -s 192.168.0.0/17 -p icmp -j ACCEPT

# HTTP from VM1
-A INPUT -s 10.0.0.5/32 -p tcp -m tcp --dport 80 -j ACCEPT

# HTTPS from VM1
-A INPUT -s 10.0.0.5/32 -p tcp -m tcp --dport 443 -j ACCEPT

# ICMP echo-request (ping) from VM1
-A INPUT -s 10.0.0.5/32 -p icmp -j ACCEPT

COMMIT
```

### Notes

- Default policy is **DROP** for `INPUT` and `FORWARD`, **ACCEPT** for `OUTPUT`.
- VM1 explicitly forwards between `wg0` (WireGuard) and `ens3` (VCN interface).
- Rules are persisted with `iptables-persistent` and reload automatically on reboot.
- Design principle: **least privilege**, only allow SSH, Prometheus metrics, ICMP, and VPN ingress.