.EXPORT_ALL_VARIABLES:
IMAGE = "jahrik/grafana"
ARCH:=$(shell uname -m)
TAG:=${ARCH}-focal
STACK = "monitor"

all: build

build:
	@docker build \
		-t ${IMAGE}:$(TAG) \
		--build-arg ARCH=${ARCH} \
		--build-arg TAG=${TAG} .

push:
	@docker push ${IMAGE}:$(TAG)

deploy:
	@docker stack deploy -c docker-compose.yml ${STACK}

.PHONY: all build push deploy
