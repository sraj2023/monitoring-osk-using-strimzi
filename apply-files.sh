#!/bin/bash

# Define the directory containing the YAML files
DIRECTORY="/Users/sraj/Desktop/monitoring-osk-using-strimzi/strimzi-0.35.1/install/cluster-operator"

# Apply each YAML file in the directory
for FILE in $DIRECTORY/*.yaml; do
  kubectl apply -f "$FILE" -n kafka
done
