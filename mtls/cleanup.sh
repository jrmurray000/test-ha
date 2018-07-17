#!/bin/bash

. ../config

kubectl config use-context ${CTX_MTLS}
kubectl delete -f mtls-auth-policy.yaml
