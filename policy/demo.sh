#!/bin/bash

if [[ $(basename `pwd`) != "org-policy" ]]; then
  echo "Must be run in org-policy dir as"
  echo "../demo.sh"
  exit 1
fi

########################
# include the magic
########################
. ../../demo-magic.sh

########################
# Configure the options
########################

#
# speed at which to simulate typing. bigger num = faster
#
TYPE_SPEED=60

#
# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

# hide the evidence
clear

# run this script from
# https://github.com:mdelio/spotlight-demo-next.git/policy/org-policy/

# show directory structure
pe "tree"

# show git repo
pe "git status"

# show synced namespaces
pe "kubectl config use-context gke_gke-on-prem-next-demo-2_us-east4-a_east-coast"
pe "kubectl get namespaces"

# add policies
pe "cp -r ../org-policy-backup/* ."
pe "tree"
pe "git add ."
pe "git commit -m \"Adding namespaces and policies.\""
pe "git push"
pe "git status"

# show synced namespaces
#pe "watch kubectl get namespaces"

# show rolebinding inheritence from orders to orders-dev
pe "kubectl get rolebinding -n orders-dev"
pe "kubectl get resourcequota -n orders-dev -o yaml"
pe "kubectl get resourcequota -n orders-staging -o yaml"
pe "kubectl get resourcequota -n orders-prod -o yaml"

#show changes to cluster #2
#pe "kubectl config use-context gke_nomos-198616_us-west1-a_nomos-cluster-2"
#pe "kubectl get ns"
cmd
