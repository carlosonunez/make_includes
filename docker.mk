#!/usr/bin/env make
.PHONY: build_docker_image
# Builds a Docker image.
# Variable: DOCKER_IMAGE_NAME: The name of the Docker image.
# Variable: DOCKER_IMAGE_TAG: The tag to apply onto the Docker image
build_docker_image: \
	_verify_variable-DOCKER_IMAGE_NAME \
	_verify_variable-DOCKER_IMAGE_TAG
build_docker_image:
	docker build -t "$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)"

.PHONY: push_docker_image_to_docker_hub
# Pushes a Docker image into Docker Hub.
# Variable: DOCKER_IMAGE_NAME: The name of the Docker image.
# Variable: DOCKER_HUB_USERNAME: The hub.docker.com username to use.
# Variable: DOCKER_HUB_PASSWORD: The hub.docker.com password to use.
# Variable: DOCKER_IMAGE_TAG: The tag to apply onto the Docker image.
push_docker_image_to_docker_hub: \
	_verify_variable-DOCKER_IMAGE_NAME \
	_verify_variable-DOCKER_HUB_USERNAME \
	_verify_variable-DOCKER_HUB_PASSWORD \
	_verify_variable-DOCKER_IMAGE_TAG
push_docker_image_to_docker_hub:
	if ! docker login --username=$(DOCKER_HUB_USERNAME) --password=$(DOCKER_HUB_PASSWORD); \
	then \
		echo -e "$(ERROR): Failed to log into Docker Hub. Check your env vars."; \
		exit 1; \
	fi; \
	docker tag $(DOCKER_IMAGE_TAG) $(DOCKER_IMAGE_NAME)
	docker push $(DOCKER_IMAGE_NAME)
