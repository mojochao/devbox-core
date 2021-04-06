#==============================================================================
#
# Makefile for building Docker images and pushing them to AWS ECR registries.
#
#==============================================================================

# Set app identity.
APP=devbox-core
VERSION := $(shell cat VERSION | tr -d '\n')

# Set Docker configuration.
DOCKERFILE ?= Dockerfile
IMAGE = mojochao/$(APP)

#==============================================================================
#
# Define help targets with descriptions provided in trailing `##` comments.
#
# Note that the '## description' is used in generating documentation when 'make'
# is invoked with no arguments.
#
# See https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html for
# additional details on how this works.
#
#==============================================================================

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

#==============================================================================
#
# Define docker targets.
#
#==============================================================================

.PHONY: docker-build
docker-build: ## Build docker image
	@echo 'building docker image $(IMAGE)'
	DOCKER_BUILDKIT=1 docker build -f $(DOCKERFILE) -t $(IMAGE):latest .
	docker tag $(IMAGE) $(IMAGE):$(VERSION)

.PHONY: docker-push
docker-push: ## Push docker image to Docker Hub
	@echo 'pushing docker image $(IMAGE):$(TAG) and latest to Docker Hub'
	docker push $(IMAGE):latest
	docker push $(IMAGE):$(VERSION)
