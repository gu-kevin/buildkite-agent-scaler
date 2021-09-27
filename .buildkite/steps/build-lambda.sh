#!/bin/bash
set -eu

build_number="${BUILDKITE_BUILD_NUMBER}"
GOCACHE=/tmp go build -ldflags="-s -w -X version.Build=${build_number}" -o ./lambda/handler ./lambda

# set a version for later steps
buildkite-agent meta-data set version \
  "$(awk -F\" '/const Version/ {print $2}' version/version.go)"
