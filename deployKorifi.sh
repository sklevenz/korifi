#!/usr/bin/env bash


echo ------------------------------------------------------------------------
echo -- install korifi
echo ------------------------------------------------------------------------

read -p "Press enter to continue"
kubectl apply -f https://github.com/cloudfoundry/korifi/releases/latest/download/install-korifi-kind.yaml

read -p "Press enter to continue"
kubectl -n korifi-installer logs --follow job/install-korifi

# read -p "Press enter to continue"
# kubectl delete namespace korifi-installer