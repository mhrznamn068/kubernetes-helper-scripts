#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <namespace>"
    echo "Example: $0 kube-system"
    exit 1
fi

NAMESPACE=$1

if ! kubectl get namespace $NAMESPACE >/dev/null 2>&1; then
    echo "Error: Namespace '$NAMESPACE' does not exist"
    exit 1
fi

get_service_usage() {
    local NAMESPACE=$1
    local SERVICE=$2
    
    cpu_usage=$(kubectl top pods -n $NAMESPACE -l app=$SERVICE 2>/dev/null | awk '{print $2}' | grep -v CPU | tr -d 'm' | tr '\n' '+' | sed 's/+$//' | bc 2>/dev/null)
    if [[ -z "$cpu_usage" ]]; then
        cpu_usage=0
    fi
    
    mem_usage=$(kubectl top pods -n $NAMESPACE -l app=$SERVICE 2>/dev/null | awk '{print $3}' | grep -v MEM | tr -d 'Mi' | tr '\n' '+' | sed 's/+$//' | bc 2>/dev/null)
    if [[ -z "$mem_usage" ]]; then
        mem_usage=0
    fi
    
    printf "║  %-19s  │  %6s            │      %10s   ║\n" "$SERVICE" "${cpu_usage}m" "${mem_usage}Mi"
}

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    TOP SERVICE USAGE                           ║"
echo "║Namespace: $NAMESPACE$(printf '%*s' $((20 - ${#NAMESPACE})) '') ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║  SERVICE              │  CPU(m)            │  MEMORY(Mi)       ║"
echo "╠═══════════════════════╪════════════════════╪═══════════════════╣"

# Get all services in the namespace
SERVICES=$(kubectl get services -n $NAMESPACE -o jsonpath='{.items[*].metadata.name}' 2>/dev/null)

if [[ -z "$SERVICES" ]]; then
    echo "No services found in namespace '$NAMESPACE'"
    exit 0
fi

# Process each service and collect results
for SERVICE in $SERVICES; do
    get_service_usage $NAMESPACE $SERVICE
done | sort -k2 -nr | head -n10

echo "╚═══════════════════════════════════════════════════════════════╝" 