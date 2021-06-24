#!/usr/bin/env bash

# Install Helm plugins

helm plugin install https://github.com/databus23/helm-diff --version 3.1.3
helm plugin install https://github.com/aslafy-z/helm-git --version 0.10.0

exec "${@}"
