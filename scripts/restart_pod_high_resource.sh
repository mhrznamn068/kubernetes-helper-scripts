#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <namespace>"
  exit 1
fi

NAMESPACE=$1
MEMORY_THRESHOLD=3700Mi
CPU_THRESHOLD=1500m

kubectl top pod -n $NAMESPACE --no-headers | while read -r pod_name cpu_usage mem_usage; do
  mem_value=${mem_usage%Mi}
  cpu_value=${cpu_usage%m}

  if [ "$mem_value" -gt "${MEMORY_THRESHOLD%Mi}" ] || [ "$cpu_value" -gt "${CPU_THRESHOLD%m}" ]; then
    echo "Restarting pod: $pod_name in namespace: $NAMESPACE (Memory: ${mem_usage}, CPU: ${cpu_usage})"
    kubectl delete pod "$pod_name" -n $NAMESPACE
  fi
done
