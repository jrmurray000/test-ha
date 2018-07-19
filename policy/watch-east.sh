#!/bin/bash

CMD="kubectl get namespaces --context gke_gke-on-prem-next-demo-2_us-east4-a_east-coast"
while :; do clear;  echo $CMD; echo; $CMD; sleep 2; done
