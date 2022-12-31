#!/usr/bin/env bash

echo ------------------------------------------------------------------------
echo -- install dashboard
echo ------------------------------------------------------------------------

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

echo ------------------------------------------------------------------------
echo -- dashboard token
echo ------------------------------------------------------------------------

kubectl -n kubernetes-dashboard create token admin-user

echo ------------------------------------------------------------------------
echo -- dashboard ui
echo ------------------------------------------------------------------------

open http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login


kubectl proxy
