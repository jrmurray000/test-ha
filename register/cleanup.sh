#!/bin/bash

KUBECONFIG=spotlight.kubeconfig
KUBECTL="kubectl --kubeconfig=${KUBECONFIG}"
MANIFEST=${HOME}/Downloads/west-gkeconnect-config.yaml

${KUBECTL} -n gke-connect delete serviceaccount/gke-connect-sa
${KUBECTL} -n gke-connect delete deployment/gke-connect-agent
rm ${MANIFEST}