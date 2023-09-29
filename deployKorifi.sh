#!/usr/bin/env bash

if [[ -z "$DOCKER_HUB_USER" ]] || [[ -z "$DOCKER_HUB_PASSWORD" ]] || [[ -z "$DOCKER_HUB_SERVER" ]]; then
  echo "usage: set environment varables: DOCKER_HUB_USER, DOCKER_HUB_PASSWORD and DOCKER_HUB_SERVER"
  exit 0
fi

echo ------------------------------------------------------------------------
echo -- export environment
echo ------------------------------------------------------------------------

export ROOT_NAMESPACE="cf"
export KORIFI_NAMESPACE="korifi-system"
export ADMIN_USERNAME="kubernetes-admin"
export BASE_DOMAIN="apps-127-0-0-1.nip.io"
export KORIFI_VERSION="0.9.0"

echo ------------------------------------------------------------------------
echo -- install namespaces
echo ------------------------------------------------------------------------

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: $ROOT_NAMESPACE
  labels:
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/enforce: restricted
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: $KORIFI_NAMESPACE
  labels:
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/enforce: restricted
EOF

echo ------------------------------------------------------------------------
echo -- install secret
echo ------------------------------------------------------------------------

kubectl --namespace "$ROOT_NAMESPACE" create secret docker-registry image-registry-credentials \
    --docker-username="$DOCKER_HUB_USER" \
    --docker-password="$DOCKER_HUB_PASSWORD" \
    --docker-server="$DOCKER_HUB_SERVER"

echo ------------------------------------------------------------------------
echo -- install korifi
echo ------------------------------------------------------------------------

echo "KORIFI_NAMESPACE:$KORIFI_NAMESPACE"
echo "ROOT_NAMESPACE:$ROOT_NAMESPACE"
echo "ADMIN_USERNAME:$ADMIN_USERNAME"
echo "BASE_DOMAIN:$BASE_DOMAIN"
echo "DOCKER_HUB_USER:$DOCKER_HUB_USER"

helm install korifi https://github.com/cloudfoundry/korifi/releases/download/v$KORIFI_VERSION/korifi-$KORIFI_VERSION.tgz \
    --namespace="$KORIFI_NAMESPACE" \
    --set=generateIngressCertificates=true \
    --set=rootNamespace="$ROOT_NAMESPACE" \
    --set=adminUserName="$ADMIN_USERNAME" \
    --set=api.apiServer.url="api.$BASE_DOMAIN" \
    --set=defaultAppDomainName="apps.$BASE_DOMAIN" \
    --set=containerRepositoryPrefix=index.docker.io/$DOCKER_HUB_USER/ \
    --set=kpackImageBuilder.builderRepository=index.docker.io/$DOCKER_HUB_USER/kpack-builder \
    --wait
