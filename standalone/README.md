# standalone

This directory contains scripts that can be used to setup and manage the full
set of registry components (including the registry server). Data is stored in a
postgres instance that is installed in the cluster and uses hostpath-storage.

These scripts must be run from the root of the repo, e.g.

```
./standalone/setup.sh
```

Note that the registry server and viewer are made available on domain names
that must be provided and pointed at your Kubernetes ingress. Before running
`./standalone/setup.sh`, set `REGISTRY_HOST` to the domain name to be used for
your API server and `VIEWER_HOST` to the domain name of your Registry Viewer.

Optionally set the `NAMESPACE` environment variable to the namespace to be used
for the installation. If unspecified, `apis` is used.

This configuration is tested using [microk8s](https://microk8s.io/) on Ubuntu
systems with the following addons installed:

```
microk8s is running
high-availability: yes
  datastore master nodes: 192.168.86.202:19001 192.168.86.205:19001 192.168.86.206:19001
  datastore standby nodes: 192.168.86.200:19001 192.168.86.201:19001 192.168.86.214:19001
addons:
  enabled:
    cert-manager         # (core) Cloud native certificate management
    dashboard            # (core) The Kubernetes dashboard
    dns                  # (core) CoreDNS
    ha-cluster           # (core) Configure high availability on the current node
    helm                 # (core) Helm - the package manager for Kubernetes
    helm3                # (core) Helm 3 - the package manager for Kubernetes
    hostpath-storage     # (core) Storage class; allocates storage from host directory
    ingress              # (core) Ingress controller for external access
    metrics-server       # (core) K8s Metrics Server for API access to service metrics
    registry             # (core) Private image registry exposed on localhost:32000
    storage              # (core) Alias to hostpath-storage add-on, deprecated
  disabled:
    community            # (core) The community addons repository
    gpu                  # (core) Automatic enablement of Nvidia CUDA
    host-access          # (core) Allow Pods connecting to Host services smoothly
    kube-ovn             # (core) An advanced network fabric for Kubernetes
    mayastor             # (core) OpenEBS MayaStor
    metallb              # (core) Loadbalancer for your Kubernetes cluster
    minio                # (core) MinIO object storage
    observability        # (core) A lightweight observability stack for logs, traces and metrics
    prometheus           # (core) Prometheus operator for monitoring and logging
    rbac                 # (core) Role-Based Access Control for authorisation
```
