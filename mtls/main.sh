#!/bin/bash

. ../demo-magic.sh
. ../config

TYPE_SPEED=100
DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

clear

kubectl config use-context ${CTX_MTLS}
kubectl delete -f mtls-auth-policy.yaml

# In another terminal run (be sure you're using CTX_MTLS:
# kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000 &
# 
# Open the following in your browser: 
# http://localhost:3000/d/LJ_uJAvmk/istio-service-dashboard?refresh=5s&panelId=90&fullscreen&orgId=1&var-service=productpage.bookinfo.svc.cluster.local&var-srcns=All&var-srcwl=All&var-dstns=All&var-dstwl=All&from=now-5m&to=now

NS="-n bookinfo"

# Step #1
p "Let's check to make sure that no policies are installed"
pe "kubectl ${NS} get Policy"
pe "kubectl ${NS} get DestinationRule"

p "Notes: 2 qps; from two 1 qps services (legacy and mesh)"

# Step #2
p "Let's turn on permissive mTLS on our services"
pe "cat permissive-auth-policy.yaml"
pe "kubectl ${NS} apply -f permissive-auth-policy.yaml"

p "Notes: 1 qps is mTLS (mesh), 1 is plain-text (legacy)"
p "We didn't break legacy!"

# Step #3
p "It turns out that the legacy service is actually rogue"
p "Let's turn on auth-policy to ensure only mTLS services can communicate with us"
pe "cat mtls-auth-policy.yaml"
pe "kubectl ${NS} apply -f mtls-auth-policy.yaml"

p "Notes: 1 qps is mTLS (mesh), the other is gone!"
p "Any additional services we add to this namespace will be protected by this policy"