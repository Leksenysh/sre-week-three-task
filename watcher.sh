#!/bin/bash

namespace="sre"        
deployment_name="swype-app" 
max_restarts=3    

while true; do
    restarts=$(kubectl get pods -n $namespace -l app=$deployment_name -o jsonpath='{.items[*].status.containerStatuses[*].restartCount}' | awk '{s+=$1} END {print s}')
    echo "Current restart count for $deployment_name: $restarts"
    if [ $restarts -gt $max_restarts ]; then
        # Step 6: Scale Down if Necessary
        echo "Maximum restart limit exceeded. Scaling down $deployment_name."
        kubectl scale deployment $deployment_name --replicas=0 -n $namespace
        break  # Exit the loop
    fi
    sleep 60
done