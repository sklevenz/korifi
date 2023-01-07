#!/usr/bin/env bash

export BASE_DOMAIN="apps-127-0-0-1.nip.io"

cf api https://api.$BASE_DOMAIN --skip-ssl-validation
cf login # choose the entry in the list associated to $ADMIN_USERNAME

