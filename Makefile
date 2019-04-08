version ?= latest
name := milad.dev
docker_image := moorara/$(name)
docker_test_image := $(name)-test

version := $(shell git rev-parse --short HEAD)
branch = $(shell git rev-parse --abbrev-ref HEAD)
commit_sha := $(shell git rev-parse --verify HEAD)
build_time := $(shell date -u +%Y-%m-%dT%H:%M:%SZ)


.PHONY: build
build:
	@ hugo --gc --minify

.PHONY: docker
docker:
	@ docker image build \
	    --build-arg VERSION="$(version)" \
	    --build-arg REVISION="$(commit_sha)" \
	    --build-arg BUILD_TIME="$(build_time)" \
	    --tag $(docker_image):$(version) \
	    .
	@ docker image tag $(docker_image):$(version) $(docker_image):latest
