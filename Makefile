.PHONY: all clean build

all: build

clean:
	-rm handler.zip

# -----------------------------------------
# Lambda management

LAMBDA_S3_BUCKET := aurora-buildkite-autoscaler-lambda
LAMBDA_S3_BUCKET_PATH := /

ifdef BUILDKITE_BUILD_NUMBER
	LD_FLAGS := -s -w -X version.Build=$(BUILDKITE_BUILD_NUMBER)
endif

ifndef BUILDKITE_BUILD_NUMBER
	LD_FLAGS := -s -w
endif

build: handler.zip

handler.zip: lambda/handler
	zip -9 -v -j $@ "$<"

lambda/handler: lambda/main.go
	docker run \
		--volume go-module-cache:/go/pkg/mod \
		--volume $(CURDIR):/go/src/github.com/buildkite/buildkite-agent-scaler \
		--workdir /go/src/github.com/buildkite/buildkite-agent-scaler \
		--rm golang:1.15 \
		go build -ldflags="$(LD_FLAGS)" -o ./lambda/handler ./lambda
	chmod +x lambda/handler

lambda-sync: handler.zip
	/opt/aurora/bin/aws s3 sync \
		--exclude '*' --include '*.zip' \
		. s3://$(LAMBDA_S3_BUCKET)$(LAMBDA_S3_BUCKET_PATH)

lambda-versions:
	/opt/aurora/bin/aws s3api head-object \
		--bucket ${LAMBDA_S3_BUCKET} \
		--key handler.zip --query "VersionId" --output text
