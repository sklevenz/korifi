#!/usr/bin/env bash

cf api https://api.$BASE_DOMAIN --skip-ssl-validation
cf login # choose the entry in the list associated to $ADMIN_USERNAME

cf create-org org1
cf target -o org1
cf create-space space1
cf target -o org1 -s space1

cd <directory of a test cf app>
cf push test-app