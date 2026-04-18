# external-apps-example

External applications catalog example for [Cozystack](https://cozystack.io). Works like a brew tap -- add this repo to your cluster and get extra apps in the Cozystack dashboard.

Currently provides managed Minecraft server and plugin apps powered by [minecraft-operator](https://github.com/lexfrei/minecraft-operator).

## Installation

Apply `init.yaml` to bootstrap the catalog in your Cozystack cluster:

```bash
kubectl apply --filename https://raw.githubusercontent.com/cozystack/external-apps-example/main/init.yaml
```

This creates a FluxCD `GitRepository` source and a `HelmRelease` that deploys the platform chart. The platform chart registers all available apps via `ApplicationDefinition` CRDs, so they appear in the Cozystack dashboard automatically.

## Available Apps

| App | Kind | Description |
| --- | --- | --- |
| minecraft-server | `MinecraftServer` | Managed PaperMC server with automatic updates, backups, and resource limits |
| minecraft-plugin | `MinecraftPlugin` | Managed plugin installation from [Hangar](https://hangar.papermc.io/) or direct URL with auto-updates |

Both apps are powered by [minecraft-operator](https://github.com/lexfrei/minecraft-operator), which is deployed automatically by the platform chart from `oci://ghcr.io/lexfrei/charts/minecraft-operator`.

## Example

Create a Minecraft server with the BlueMap plugin (see `examples/minecraft.yaml`):

```yaml
apiVersion: apps.cozystack.io/v1alpha1
kind: MinecraftServer
metadata:
  name: survival
  namespace: tenant-root
spec:
  updateStrategy: latest
  memoryLimit: 2Gi
  cpuLimit: 2000m
  serviceType: NodePort
---
apiVersion: apps.cozystack.io/v1alpha1
kind: MinecraftPlugin
metadata:
  name: bluemap
  namespace: tenant-root
spec:
  sourceType: hangar
  project: BlueMap
  updateStrategy: latest
  instanceSelector:
    matchLabels:
      app.kubernetes.io/instance: minecraft-survival
  endpoints:
    - name: web
      port: 8100
      protocol: HTTP
```

## Repository Structure

```text
init.yaml                          # Bootstrap manifest (GitRepository + HelmRelease)
packages/
  core/platform/                   # Platform chart: namespaces, HelmCharts, HelmReleases, ApplicationDefinitions
  apps/minecraft-server/           # Helm chart wrapping PaperMCServer CRD
  apps/minecraft-plugin/           # Helm chart wrapping Plugin CRD
examples/
  minecraft.yaml                   # Server + BlueMap plugin example
```
