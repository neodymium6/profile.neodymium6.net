---
title: "Homelab"
---

## Overview {#overview}

I run a self-hosted homelab on Proxmox VE, fully automated with Infrastructure as Code.
The entire stack—from VM provisioning to service deployment—is managed by Terraform and Ansible, requiring only a single `make all` command to deploy from scratch.

![Homelab Grafana dashboard](/images/hobbies/homelab/homelab-grafana-dashboard.webp)

Source code: [[GitHub]](https://github.com/neodymium6/homelab)

## Architecture {#architecture}

The homelab follows a bastion host pattern. My local machine provisions a bastion VM, which then acts as the infrastructure controller for all internal VMs. Internal VMs are not directly accessible from outside—SSH access is restricted to the bastion only.

| VM | Role | Services |
|----|------|----------|
| bastion-01 | Infrastructure controller | Terraform, Ansible |
| dns-01 | DNS | Unbound, AdGuard Home |
| proxy-01 | Reverse proxy | Traefik, Cloudflare Tunnel |
| app-01 | Applications | Docker, Prometheus, Grafana, Homepage, Personal Site |

## Tech Stack {#tech-stack}

- **Provisioning**: Terraform (Proxmox provider) + Ansible (multiple vendored roles)
- **Reverse Proxy**: Traefik with Let's Encrypt wildcard certificates (Cloudflare DNS challenge)
- **DNS**: Unbound (recursive resolver) + AdGuard Home (ad filtering)
- **Monitoring**: Prometheus + Grafana + Node Exporter on all VMs
- **Containers**: Docker + Docker Compose
- **System Config**: Nix + Home Manager
- **Public Access**: Cloudflare Tunnel for selective service exposure

## Key Design Decisions {#design-decisions}

- **Single source of truth**: All VM definitions, network settings, and service configurations live in one `cluster.yaml` file. Terraform, Ansible, and DNS records are all generated from it.
- **Security by default**: UFW firewalls on every VM, SSH key-only authentication, internal VMs reachable only from the bastion, per-service IP whitelisting and basic auth via Traefik.
- **Idempotent deployment**: Running `make all` on a fresh machine produces the same result every time.
