#!/bin/bash
set -eu

export AWS_DEFAULT_REGION=us-east-1
# export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-$SANDBOX_AWS_ACCESS_KEY_ID}
# export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-$SANDBOX_AWS_SECRET_ACCESS_KEY}

EXTRA_REGIONS=(
  us-east-2
  us-west-1
  us-west-2
  af-south-1
  ap-east-1
  ap-south-1
  ap-northeast-2
  ap-northeast-1
  ap-southeast-2
  ap-southeast-1
  ca-central-1
  eu-central-1
  eu-west-1
  eu-west-2
  eu-south-1
  eu-west-3
  eu-north-1
  me-south-1
  sa-east-1
)

VERSION=$(buildkite-agent meta-data get "version")
BASE_BUCKET=aurora-buildkite-lambda
BUCKET_PATH="buildkite-agent-scaler"

if [[ "${1:-}" == "release" ]] ; then
  BUCKET_PATH="${BUCKET_PATH}/v${VERSION}"
else
  BUCKET_PATH="${BUCKET_PATH}/builds/${BUILDKITE_BUILD_NUMBER}"
fi

echo "~~~ :buildkite: Downloading artifacts"
buildkite-agent artifact download handler.zip .

echo "--- :s3: Uploading lambda to ${BASE_BUCKET}/${BUCKET_PATH}/ in ${AWS_DEFAULT_REGION}"
aws s3 cp handler.zip "s3://${BASE_BUCKET}/${BUCKET_PATH}/handler.zip"
