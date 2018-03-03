#!/usr/bin/env make
.PHONY: run_ruby_command_%
# Runs an arbitrary Ruby command.
# Variable: RUBY_COMMAND: The command to run, including arguments
run_ruby_command_%: \
	_verify_variable-RUBY_COMMAND
run_ruby_command_%:
	echo -e "$(INFO) Ruby: Running 'ruby $(RUBY_COMMAND)'"; \
	docker run --rm -t -v $$PWD:/work -w /work \
		-v $$PWD/.gem:/root/.gem \
		-v $$HOME/.aws:/root/.aws \
		-v $$PWD/.bundle:/root/.bundle \
		-v $$PWD:/work \
		-w /work \
		--env-file .env \
		-e GEM_HOME=/root/.gem \
		-e BUNDLE_PATH=/root/.gem \
		$(RUBY_DOCKER_IMAGE) $(RUBY_COMMAND)
