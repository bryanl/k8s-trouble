#!/bin/bash
#
# install metrics server

set -e

kubectl apply -f https://gist.githubusercontent.com/bryanl/f1dafe77b5148b9e3d07a88ea7e25223/raw/2ea2ba0f759df401a30af5668b3bac8bb552a387/metrics-server.yaml
