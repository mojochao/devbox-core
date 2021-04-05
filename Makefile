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
IMAGE = github.com/mojochao/$(APP)

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

.PHONY: docker-tag
docker-tag: ## Tag docker image for pushing to Dockerhub
	@echo 'tagging docker image with latest,$(VERSION) tags for push to Dockerhub'
	docker tag $(IMAGE) $(IMAGE):$(VERSION)

.PHONY: docker-login
docker-login: ## Login to Dockerhub for pushing docker images.
	@echo 'logging in to Dockerhub'
	@eval $(ECR_LOGIN_CMD)

.PHONY: docker-push
docker-push: ## Push tagged docker images to Dockerhub
	@echo 'pushing docker image with latest,$(VERSION) tags to Dockerhub'
	docker push $(ECR_REPO)/$(IMAGE):latest
	docker push $(ECR_REPO)/$(IMAGE):$(VERSION)
