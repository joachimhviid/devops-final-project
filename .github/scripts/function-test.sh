#!/bin/bash
kubectl apply -f manifests/

# Get the JSON output from kubectl get nodes
nodes_json_output=$(kubectl get nodes -o json)

# Get external ip from JSON format
external_ips=$(echo "$nodes_json_output" | jq -r '.items[].status.addresses[] | select(.type == "ExternalIP") | .address')

# check
if [ -z "$external_ips" ]; then
    echo "No external IPs found."
else
    echo "External IPs of the nodes:"
    echo "$external_ips"
fi

# Get the JSON output from kubectl get services
service_json_output=$(kubectl get services -o json)

# Get port from service
SERVICE_NAME="frontend"
service_port=$( echo $service_json_output | jq -e ".items[] | select(.metadata.name | contains(\"$SERVICE_NAME\")).spec.ports[0].nodePort")

#check
if [ -z "$service_port" ]; then
    echo "No port found on service: $SERVICE_NAME "
fi

# Get the first external ip from the list
external_ip=$(echo "$external_ips" | head -n 1) 

# Check connection
URL=$external_ip:$service_port
timeout 10 sh -c "until curl '${URL}'; do echo 'Sleeping...'; sleep 1; done"
EXIT_CODE="$?"

# Clean-up with exit code if fail
kubectl delete -f manifests/
EXIT_CODE_2="$?"
if [ "$EXIT_CODE_2" -ne 0 ]; then
    exit "$EXIT_CODE_2"
fi

#exit code for curl
exit "$EXIT_CODE"