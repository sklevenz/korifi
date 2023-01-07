#/usr/bin/env bash

echo ---------------------------------------------------
echo -- uninstall korifi
echo ----------------------------------------------------

helm uninstall -n korifi-system korifi

