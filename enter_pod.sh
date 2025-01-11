#!/bin/bash

# Check if a pod name is provided
if [ -z "$1" ]; then
  echo "Usage: ./enter_pod_ssh.sh <pod_name>"
  exit 1
fi

POD_NAME="$1"

# Run the PHP script to get the pod ID by pod name
POD_ID=$(php get_pod.php "$POD_NAME")

if [ -z "$POD_ID" ]; then
  echo "Pod with name '$POD_NAME' not found. Exiting."
  exit 1
fi

# Now enter the container's shell using podman exec
echo "Entering SSH session for pod '$POD_NAME' (ID: $POD_ID)..."
podman exec -it "$POD_ID" bash

