# Kubernetes Helper Scripts

This repository contains a collection of Kubernetes helper scripts designed to assist in day-to-day operations. These scripts simplify common Kubernetes tasks such as restarting pods based on resource usage and monitoring namespace resource consumption.

## Available Scripts

### 1. `restart_pod_high_resource.sh`

This script identifies and restarts pods in a specified namespace that are consuming more than a specified CPU or memory threshold.

#### Usage:
```bash
curl -s https://raw.githubusercontent.com/mhrznamn068/kubernetes-helper-scripts/main/scripts/restart_pod_high_resource.sh | bash -s <namespace>
```

### 2. `top_usage_by_ns.sh`

This script identifies the namespace's with high resource utilization and outputs the total sum of the resource consumption.

#### Usage:
```bash
curl -s https://raw.githubusercontent.com/mhrznamn068/kubernetes-helper-scripts/main/scripts/top_usage_by_ns.sh | bash -s cpu
curl -s https://raw.githubusercontent.com/mhrznamn068/kubernetes-helper-scripts/main/scripts/top_usage_by_ns.sh | bash -s memory
```