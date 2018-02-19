#!/usr/bin/env make
.PHONY: bundle_%
# Runs a Bundle command with AWS context.
# Variable: AWS_REGION: The AWS region to perform work within.
# Variable: AWS_ACCESS_KEY_ID: The AWS access key to use.
# Variable: AWS_SECRET_ACCESS_KEY: The AWS secret key to use.
bundle_%: \
	_verify_variable-AWS_REGION \
	_verify_variable-AWS_ACCESS_KEY_ID \
	_verify_variable-AWS_SECRET_ACCESS_KEY
bundle_%: \
	RUBY_DOCKER_IMAGE=ruby:2.4-alpine3.7
bundle_%: \
	BUNDLE_ACTION=$(shell echo "$@" | cut -f3 -d ' ' | cut -f2 -d '_')
bundle_%:
	echo -e "$(INFO) Performing Bundle action: $(BUNDLE_ACTION)"; \
	if [ ! -z "$(BUNDLE_OPTIONS)" ]; \
	then \
		echo -e "$(INFO) Options provided to Bundle: $(BUNDLE_OPTIONS)"; \
	fi; \
	docker run --rm -t -v $$PWD:/work -w /work \
		-v $$PWD/.gem:/root/.gem \
		-v $$HOME/.aws:/root/.aws \
		-v $$PWD/.bundle:/root/.bundle \
		-v $$PWD:/work \
		-w /work \
		--env-file .env \
		-e GEM_HOME=/root/.gem \
		-e BUNDLE_PATH=/root/.gem \
		-e AWS_ACCESS_KEY_ID \
		-e AWS_SECRET_ACCESS_KEY \
		-e AWS_REGION \
		$(RUBY_DOCKER_IMAGE) bundle $(BUNDLE_ACTION) $(BUNDLE_OPTIONS)
