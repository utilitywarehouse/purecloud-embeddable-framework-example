GIT_HASH := $(shell git rev-parse HEAD)

# ----- Installing -----

.PHONY: install
install:
	npm ci


# ----- Docker -----

NAMESPACE=crm
DOCKER_REGISTRY=registry.uw.systems
DOCKER_CONTAINER_NAME=purecloud-embeddable-framework-example
DOCKER_REPOSITORY=$(DOCKER_REGISTRY)/$(NAMESPACE)/$(DOCKER_CONTAINER_NAME)

docker-image:
	@docker build  -f ./Dockerfile --rm \
		-t $(DOCKER_REPOSITORY):local \
		.

# ----- CI -----

ci-docker-auth:
	@echo "Logging in to $(DOCKER_REGISTRY) as $(DOCKER_ID)"
	@docker login -u $(DOCKER_ID) -p $(DOCKER_PASSWORD) $(DOCKER_REGISTRY)

ci-docker-build: ci-docker-auth
	@docker build -f ./Dockerfile --no-cache \
		-t $(DOCKER_REPOSITORY):$(GIT_HASH) \
		.

ci-docker-push: ci-docker-auth
	docker tag $(DOCKER_REPOSITORY):$(GIT_HASH) $(DOCKER_REPOSITORY):latest
	docker push --all-tags $(DOCKER_REPOSITORY)
