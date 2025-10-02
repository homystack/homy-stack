# Vaultwarden Component

A Crossplane composition for deploying and managing Vaultwarden (Bitwarden-compatible) password manager with automatic backups and TLS.

## Overview

This component provides a declarative way to deploy Vaultwarden - a self-hosted, open-source password manager compatible with Bitwarden clients. It includes built-in backup/restore capabilities and automatic TLS certificate management.

## Features

- **Vaultwarden Deployment**: Deploys Vaultwarden via Helm chart with configurable options
- **Automatic Backups**: Built-in backup scheduling using K8up with support for S3 and backup server backends
- **Restore Capabilities**: One-click restore from existing backups
- **TLS Management**: Automatic certificate provisioning via cert-manager
- **Database Support**: SQLite (default), MySQL, and PostgreSQL
- **SMTP Integration**: Email notifications and user verification
- **Ingress Configuration**: Automatic ingress setup with custom annotations
- **Resource Management**: Configurable CPU and memory limits

## Quick Start

```yaml
apiVersion: apps.homystack.com/v1alpha1
kind: VaultWarden
metadata:
  name: my-vault
  namespace: default
spec:
  persistence:
    enabled: true
    size: "5Gi"
    storageClass: "local-path"
  database:
    type: "sqlite"
  ingress:
    enabled: true
    host: "vaultwarden.example.com"
    className: "nginx"
  backup:
    schedule: "0 2 * * *"
    backend: "backupServer"
    repoPassword:
      strategy: "generate"
    backupServer:
      ref:
        namespace: default
        name: my-backup
  config:
    domain: "https://vaultwarden.example.com"
    allowSignups: true
    enableWebVault: true
```

## Configuration

### Required Fields

- `persistence.enabled`: Enable persistent storage (required for SQLite)
- `database.type`: Database type (sqlite, mysql, postgresql)

### Optional Fields

- `persistence.size`: Storage size (default: "1Gi")
- `persistence.storageClass`: Storage class name
- `ingress.enabled`: Enable ingress (default: false)
- `ingress.host`: Hostname for ingress
- `backup`: Backup configuration
  - `backup.schedule`: Cron schedule for backups
  - `backup.backend`: Backup storage backend (s3, backupServer)
  - `backup.repoPassword`: Repository password strategy
- `config`: Vaultwarden runtime configuration
  - `config.domain`: Base domain for Vaultwarden
  - `config.allowSignups`: Allow new user registrations
  - `config.enableWebVault`: Enable web interface
  - `config.smtp`: SMTP configuration for emails

## Backup Configuration

### Using Backup Server (Recommended & Tested)

```yaml
backup:
  schedule: "0 2 * * *"
  backend: "backupServer"
  repoPassword:
    strategy: "generate"  # or "direct", "existingSecret"
  backupServer:
    ref:
      namespace: default
      name: my-backup
```

### Using S3 Storage (⚠️ UNTESTED - May be broken)

```yaml
backup:
  schedule: "0 2 * * *"
  backend: "s3"
  s3:
    endpoint: "https://s3.amazonaws.com"
    bucket: "my-backups-vaultwarden"
    region: "us-east-1"
    accessKeySecret: "vaultwarden-s3-accesskey"
    secretKeySecret: "vaultwarden-s3-secretkey"
```

## Restore from Backup

To restore from an existing backup:

```yaml
restore:
  backend: "backupServer"
  repoPassword:
    strategy: "existingSecret"
    secretRef:
      name: "my-vault-backup-password"
      key: "password"
  backupServer:
    ref:
      namespace: default
      name: my-backup
    repositoryName: my-vault-vaultwarden
  snapshot: "abc123"  # Optional: specific snapshot ID
  method: "folder"
```

## Database Options

### SQLite (Default)
```yaml
database:
  type: "sqlite"
```

### MySQL/PostgreSQL
```yaml
database:
  type: "mysql"
  url: "mysql://user:pass@mysql-server:3306/vaultwarden"
  existingSecret: "mysql-credentials"
```

## SMTP Configuration

```yaml
config:
  smtp:
    enabled: true
    host: "smtp.gmail.com"
    port: 587
    from: "vaultwarden@example.com"
    user: "vaultwarden@example.com"
    passwordSecret: "vaultwarden-smtp-password"
    security: "starttls"
```

## Architecture

The component creates:
- **HelmRelease**: Vaultwarden deployment via Helm
- **Certificate**: TLS certificate via cert-manager (if enabled)
- **Schedule**: Backup schedule via K8up
- **Restore Job**: One-time restore job (if configured)

## Dependencies

- Crossplane with Go Templating function
- FluxCD for Helm releases
- cert-manager for TLS certificates
- K8up for backup/restore operations
- Optional: BackupServer component for backup storage

## ⚠️ Important Notes

- **S3 Backup**: S3 backend configuration is currently UNTESTED and may not work correctly
- **Backup Server**: This is the recommended and tested backup method
- **Restore**: Restore functionality has been tested with backup server backend

## Examples

- [example.yaml](./example.yaml) - Basic deployment with backup server
- [example-restore.yaml](./example-restore.yaml) - Deployment with restore configuration
