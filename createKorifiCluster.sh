#!/usr/bin/env bash

echo ------------------------------------------------------------------------
echo -- install cluster
echo ------------------------------------------------------------------------

if [ "$(kind get clusters)" != "korifi-cluster" ]; then

cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: korifi-cluster
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF

else
echo "[LOG] cluster is already running..."
fi

kind get clusters
kind get nodes -n korifi-cluster
mkdir -p gen
kind get  kubeconfig -n korifi-cluster > ./gen/kubeconfig.yml
