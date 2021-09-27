#!/bin/bash
set -eu

go build -ldflags="-s -w -X version.Build=$(BUILDKITE_BUILD_NUMBER)" -o ./lambda/handler ./lambda

# set a version for later steps
buildkite-agent meta-data set version \
  "$(awk -F\" '/const Version/ {print $2}' version/version.go)"
