#!/usr/bin/env bash

kind delete cluster -n korifi-cluster
rm -rf ./gen
mkdir gen
