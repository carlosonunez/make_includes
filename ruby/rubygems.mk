#!/usr/bin/env make
.PHONY: _build_gem
# Builds a Ruby gem.
# Variable: GEMSPEC_NAME: The name of the gemspec file to build.
_build_gem: \
	_verify_variable-GEMSPEC_NAME
_build_gem: RUBY_DOCKER_IMAGE=ruby:2.4-alpine3.7
_build_gem:
	docker run --rm -it -v $$PWD:/work -w /work \
		-v $$PWD/.gem:/root/.gem \
		-e GEM_HOME=/root/.gem \
		-e BUNDLE_PATH=/root/.gem \
		$(RUBY_DOCKER_IMAGE) gem build $(GEMSPEC_NAME)
