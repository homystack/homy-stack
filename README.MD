

# 🏠 hoMYstack

> **Your cloud. Your rules. Your stack.**

hoMYstack is an open-source self-hosting platform built on Kubernetes.  
It turns your homelab into a **declarative cloud**, where every service is described through a unified API.

No Docker Compose. No scripts.  
Just `kubectl apply -f vaultwarden.yaml` — and you get **Vaultwarden with TLS, backups, and monitoring out of the box**.

---

## 🔧 What’s Included (MVP)

hoMYstack currently covers three core use cases:

| Service | Function |
|--------|---------|
| [`VaultWarden`](./examples/vaultwarden.yaml) | Password management with automatic TLS and backups |
| [`Restic Backup Server`](./examples/restic-server.yaml) | Centralized, encrypted storage for backups |
| [`Samba Share`](./examples/samba.yaml) | Simple file access from any device |

All components:
- Deployed via CRDs (`kind: VaultWarden`)
- Include built-in backups (via k8up + Restic)
- Automatically get TLS (cert-manager + Let's Encrypt / DuckDNS)
- Managed via GitOps (Flux)

---

## 🚀 Quick Start

1. Install [k3s](https://k3s.io/) or any K8s cluster (single-node is fine).
2. Deploy hoMYstack:
   ```bash
    TODO
   ```
3. Spin up your first service:
   ```bash
   kubectl apply -f examples/vaultwarden.yaml
   ```
4. In 2 minutes:  
   → `https://vault.myhome.net` (with green lock)  
   → Nightly backups  
   → Status: `kubectl get vaultwarden`

---

## 👀 UI? Yes.

We use [Headlamp](https://headlamp.k8s.dev/) — a lightweight, open-source dashboard.  

There you’ll see:
- All your `VaultWarden`, `ResticRepo`, `SambaShare` resources
- Status, PVCs, secrets, events
- No magic buttons — just **the real state of your cluster**

> 💡 This isn’t a custom UI. It’s a tool for those who want to see what’s happening.

---

## 📦 Why hoMYstack?

- ✅ **Not DIY sysadmin work** — everything is automated: TLS, backups, updates.
- ✅ **Not a pile of scripts** — everything is defined in YAML, easy to version and reproduce.
- ✅ **Not "yet another Helm chart"** — it’s a CRD-based platform: you say *what* you want, not *how*.
- ✅ **Runs on N100, Raspberry Pi, old PC** — energy-efficient and silent.

> hoMYstack is an attempt to replace manual work with Nginx, ports, and cron scripts  
> with a **unified, reproducible system for managing home services**.

---

## 🌱 Roadmap

- [ ] Headlamp forms: create services without YAML
- [ ] Node auto-discovery: plug in a mini-PC → joins cluster automatically
- [ ] Service catalog: “Want Nextcloud? Click here”

---

## 🤝 Contributing

hoMYstack is open-core:
- **Core (MVP)** — Apache 2.0, free for everyone
- **Enterprise components** (maybe in future after requests) — will be under BSL 1.1 (free for home, paid for enterprise)

You can:
- Add new CRDs (e.g., `kind: Immich`)
- Write plugins for Headlamp
- Distribute hoMYstack as an appliance

**Anything that runs on Kubernetes can become part of hoMYstack.**

---

## 🙏 Acknowledgements

Thanks to the projects we build upon:
- [k3s](https://k3s.io/) — lightweight Kubernetes
- [Flux](https://fluxcd.io/) — GitOps for infrastructure
- [Crossplane](https://www.crossplane.io/) — CRDs over others resources
- [cert-manager](https://cert-manager.io/) — TLS in seconds
- [k8up](https://k8up.io/) — simple, reliable backups
- [Headlamp](https://headlamp.k8s.dev/) — clean UI, no bloat

---

## 📣 Author

hoMYstack is created by Maxim Beliy (aka Kitsunoff) as an open-source project and movement for **digital sovereignty at home**.  
First live demo at Homelab Meetup, 2025.

> If you’re tired of being your own sysadmin — maybe you need hoMYstack.

---

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
```
