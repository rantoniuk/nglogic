#!/bin/bash

# example test script using Bash + curl

while true
do
  version=$(curl --max-time 1 --silent $1 --stderr - | sed -n 's:.*<title>\(.*\)</title>.*:\1:p')

  if [ "$version" == "" ]; then
    echo "$(date -u) Service Unavailable"
  else
    echo "$(date -u) $version"
  fi

  sleep 1
done
