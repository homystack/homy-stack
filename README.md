# homy-stack

External applications catalog for [Cozystack](https://cozystack.io) focused on homelab workloads. Works like a brew tap — add this repo to your cluster and get extra apps in the Cozystack dashboard.

## Installation

Apply `init.yaml` to bootstrap the catalog in your Cozystack cluster:

```bash
kubectl apply --filename https://raw.githubusercontent.com/homystack/homy-stack/v2/init.yaml
```

This creates a FluxCD `GitRepository` source and a `HelmRelease` that deploys the platform chart. The platform chart registers all available apps via `ApplicationDefinition` CRDs, so they appear in the Cozystack dashboard automatically.

## Repository Structure

```text
init.yaml                          # Bootstrap manifest (GitRepository + HelmRelease)
packages/
  core/platform/                   # Platform chart: namespaces, HelmCharts, HelmReleases, ApplicationDefinitions
  apps/                            # Individual Helm charts per homelab app
examples/                          # Example manifests per app
scripts/package.mk                 # Shared Makefile include for packaging charts
```
