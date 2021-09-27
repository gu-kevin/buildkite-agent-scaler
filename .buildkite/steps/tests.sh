#!/bin/bash
set -euo pipefail
echo "Get user id"
echo $UID

ls -la /go/src

GO111MODULE=off GOCACHE=/tmp go get gotest.tools/gotestsum

echo '+++ Running tests'
gotestsum --junitfile "junit-${OSTYPE}.xml" -- -count=1 -failfast ./...
