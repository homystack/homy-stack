# Backup Server Component

A Crossplane composition for deploying a REST server for restic backups with optional web UI.

## Overview

This component provides a declarative way to deploy a backup server using [restic/rest-server](https://github.com/restic/rest-server) with optional [backrest](https://github.com/garethgeorge/backrest) web interface for monitoring and managing backups.

## Features

- **REST Server**: Deploys restic/rest-server for storing encrypted backups
- **Optional Web UI**: Backrest dashboard for monitoring backup status and statistics
- **Persistent Storage**: Configurable storage size and storage class
- **Resource Management**: Configurable CPU and memory limits
- **Service Exposure**: Support for ClusterIP, LoadBalancer, and NodePort services
- **Ingress Support**: Optional ingress configuration with TLS
- **Node Placement**: Configurable node selector for pod scheduling

## Quick Start

```yaml
apiVersion: apps.homystack.com/v1alpha1
kind: BackupServer
metadata:
  name: my-backup
  namespace: default
spec:
  image: "restic/rest-server:0.14.0"
  persistence:
    enabled: true
    size: "50Gi"
    storageClass: "local-path"
  resources:
    requests:
      memory: "512Mi"
      cpu: "200m"
    limits:
      memory: "1Gi"
      cpu: "500m"
  service:
    type: "LoadBalancer"
  ingress:
    enabled: true
    host: "backup.example.com"
    className: "nginx"
  config:
    options: "--prometheus --debug"
  ui:
    ingress:
      host: backrest.example.com
```

## Configuration

### Required Fields

- `image`: Container image for the REST server (default: "restic/rest-server:0.14.0")
- `persistence.enabled`: Whether to enable persistent storage
- `resources`: CPU and memory requests/limits
- `service.type`: Service type (ClusterIP, LoadBalancer, NodePort)

### Optional Fields

- `persistence.size`: Storage size (default: "10Gi")
- `persistence.storageClass`: Storage class name
- `ingress.enabled`: Enable ingress (default: false)
- `ingress.host`: Hostname for ingress
- `config.options`: Additional CLI flags for the server
- `ui`: Backrest web UI configuration
  - `ui.image`: Backrest image (default: "garethgeorge/backrest:latest")
  - `ui.ingress.host`: Hostname for UI ingress

## Usage with Restic

Once deployed, you can use the backup server with restic:

```bash
# Initialize repository
restic -r rest:http://backup-server-url:8000/my-repo init

# Backup data
restic -r rest:http://backup-server-url:8000/my-repo backup /path/to/data
```

## Architecture

The component creates:
- **StatefulSet**: For the REST server with persistent volume
- **Service**: For internal and external access
- **Optional Ingress**: For external HTTP access
- **Optional UI StatefulSet**: For backrest web interface

## Dependencies

- Crossplane with Go Templating function
- Kubernetes cluster with storage provisioner
- Optional: Ingress controller for external access

## Examples

See [example.yaml](./example.yaml) for a complete configuration example.
