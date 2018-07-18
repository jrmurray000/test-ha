#!/bin/bash

. ../config

echo "========================="
echo "Open Browser to this URL:"
echo "========================="
echo "http://localhost:3000/d/LJ_uJAvmk/istio-service-dashboard?refresh=5s&panelId=90&fullscreen&orgId=1&var-service=productpage.bookinfo.svc.cluster.local&var-srcns=All&var-srcwl=All&var-dstns=All&var-dstwl=All&from=now-5m&to=now"

# In another terminal run (be sure you're using CTX_MTLS:
echo ""
echo "====================="
echo "hit ctrl-c when done:"
echo "====================="
kubectl --context ${CTX_MTLS} -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000
