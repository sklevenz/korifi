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

helm install korifi https://github.com/cloudfoundry/korifi/releases/download/v0.5.0/korifi-0.5.0.tgz \
    --namespace="$KORIFI_NAMESPACE" \
    --set=global.generateIngressCertificates=true \
    --set=global.rootNamespace="$ROOT_NAMESPACE" \
    --set=adminUserName="$ADMIN_USERNAME" \
    --set=api.apiServer.url="api.$BASE_DOMAIN" \
    --set=global.defaultAppDomainName="apps.$BASE_DOMAIN" \
    --set=global.containerRepositoryPrefix=index.docker.io/$DOCKER_HUB_USER/ \
    --set=api.packageRepository=index.docker.io/$DOCKER_HUB_USER/packages \
    --set=kpack-image-builder.builderRepository=index.docker.io/$DOCKER_HUB_USER/kpack-builder \
    --set=kpack-image-builder.dropletRepository=index.docker.io/$DOCKER_HUB_USER/droplets \
    --wait



