#!/bin/bash
set -euo pipefail

GO111MODULE=off GOCACHE=/tmp go get gotest.tools/gotestsum

echo '+++ Running tests'
GOCACHE=/tmp gotestsum --junitfile "junit-${OSTYPE}.xml" -- -count=1 -failfast ./...
