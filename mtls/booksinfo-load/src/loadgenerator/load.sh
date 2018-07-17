#!/bin/sh

while true; do
	curl -l -sS -o /dev/null http://${FRONTEND_ADDR}/productpage -k --connect-timeout 2
	sleep 1
done