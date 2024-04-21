#!/usr/bin/env bash

kind delete cluster -n korifi
rm -rf ./gen
mkdir gen
