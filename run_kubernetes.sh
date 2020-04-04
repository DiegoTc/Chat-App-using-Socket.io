#!/usr/bin/env bash

# This tags and uploads an image to Docker Hub

# Step 1:
# This is your Docker ID/path
dockerpath=diegotc/chat-channel

# Step 2
# Run the Docker Hub container with kubernetes
kubectl create deployment chat --image=$dockerpath

# Step 3:
# List kubernetes pods
kubectl get pods

# Step 4:
# Forward the container port to a host
kubectl expose deployment/chat --type="LoadBalancer" --port 5000
