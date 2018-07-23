#!/bin/bash

. ../demo-magic.sh

KUBECONFIG=spotlight.kubeconfig
KUBECTL="kubectl --kubeconfig=${KUBECONFIG}"

TYPE_SPEED=100
DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

clear

MANIFEST=${HOME}/Downloads/west-gkeconnect-config.yaml

if [ ! -e ${MANIFEST} ]; then
    echo "need to have manifest file at ${MANIFEST} to continue"
    exit 1
fi


pe "less ${MANIFEST}"

pe "${KUBECTL} apply -f ${MANIFEST}"

pe "${KUBECTL} config view --minify --flatten"

SECRET=$(${KUBECTL} -n gke-connect get secrets -o name | grep gke-connect-sa-token)
${KUBECTL} -n gke-connect get ${SECRET} -o=custom-columns=TOKEN:.data.token --no-headers | base64 -D > creds.txt
pe "cat creds.txt"
echo ""
