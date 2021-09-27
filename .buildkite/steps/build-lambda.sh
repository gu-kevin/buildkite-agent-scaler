#!/bin/bash
set -eu

GOCACHE=/tmp go build -ldflags="-s -w -X version.Build=${BUILDKITE_BUILD_NUMBER}" -o ./lambda/handler ./lambda
zip -9 -v -j $@ "$<"

# set a version for later steps
buildkite-agent meta-data set version \
  "$(awk -F\" '/const Version/ {print $2}' version/version.go)"
