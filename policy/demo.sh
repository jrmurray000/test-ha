#!/bin/bash

########################
# include the magic
########################
. ../demo-magic.sh

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

# run this script from root of git repository @ https://github.com/jrmurray000/foo-corp-example

# show directory structure
pe "tree"

# show synced namespaces 
pe "kubectl get namespaces"

# show rolebinding inheritence from shipping-app-backend to shipping dev
pe "cat org-policy/online/shipping-app-backend/pod-creator-rolebinding.yaml"
pe "tree"
pe "kubectl get rolebinding -n shipping-dev"

# test inherited shipping-dev rolebinding for bob - secrets fails, pods succeeds
pe "kubectl get secrets -n shipping-dev --as bob@foo-corp.com"
pe "kubectl get pods -n shipping-dev --as bob@foo-corp.com"

# demonstrate hierarchical resource quota
pe "tree"
pe "cat org-policy/online/shipping-app-backend/quota.yaml"

# create a pod that exceeds the hierarchical quota
pe "cat <<EOF | kubectl create --as bob@foo-corp.com -f -
apiVersion: v1
kind: Pod
metadata:
  name: busybox-sleep
  namespace: shipping-prod
spec:
  containers:
  - name: busybox
    image: busybox
    args:
    - sleep
    - \"1000000\"
    resources:
      requests:
        memory: \"64Mi\"
        cpu: \"2\"
EOF"

# reduce the CPU to 20%
pe "cat <<EOF | kubectl create --as bob@foo-corp.com -f -
apiVersion: v1
kind: Pod
metadata:
  name: busybox-sleep
  namespace: shipping-prod
spec:
  containers:
  - name: busybox
    image: busybox
    args:
    - sleep
    - \"1000000\"
    resources:
      requests:
        memory: \"64Mi\"
        cpu: \"200m\"
EOF"

# create a namespace for the front end developers

pe "mkdir org-policy/online/shipping-app-frontend"

pe  "cat <<EOF > org-policy/online/shipping-app-frontend/namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: shipping-app-frontend
EOF"
pe "git add ."
pe "git commit -m \"Adding frontend namespace.\""
pe "git push"

# show namespace has synced
pe "watch kubectl get ns"

tree
#missing a pod creator rolebinding for Bob
pe "kubectl get rolebindings -n shipping-app-frontend"

# move the rolebinding higher and push the commit
pe "mv org-policy/online/shipping-app-backend/pod-creator-rolebinding.yaml org-policy/online/"
pe "git add ."
pe "git commit -m \"Moving rolebinding for shipping app pod creators.\""
pe "git push"

# show new rolebinding exists
pe "watch kubectl get rolebindings -n shipping-app-frontend"

#show changes to cluster #2
pe "kubectl config use-context gke_nomos-198616_us-west1-a_nomos-cluster-2"
pe "kubectl get ns"
cmd
