#!/usr/bin/env bash

cf create-org org && cf create-space -o org space && cf target -o org

cd cf-example-app
cf push test-app

open https://test-app.apps-127-0-0-1.nip.io/
     