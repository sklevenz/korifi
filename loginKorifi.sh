#!/usr/bin/env bash

cf api https://localhost --skip-ssl-validation
cf auth kind-korifi
cf login 

