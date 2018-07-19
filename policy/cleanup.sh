#!/bin/bash
if [[ $(basename `pwd`) != "org-policy" ]]; then
  echo "Must be run in org-policy dir as"
  echo "../cleanup.sh"
  exit 1
fi
rm -rf `ls |grep -v README`
git add .
git commit -m "cleanup namespaces and policies."
git push
