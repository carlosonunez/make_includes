#!/usr/bin/env make
.PHONY: rubocop
# Performs a Rubocop run.
# Variable: RUBOCOP_OPTIONS: Options to pass into Rubocop
rubocop: BUNDLE_OPTIONS=rubocop $(RUBOCOP_OPTIONS)
rubocop: bundle_exec

.PHONY: rspec
# Performs a RSpec run.
# Variable: RSPEC_OPTIONS: Options to provide to RSpec.
# 				  Variable required if .rspec is not present.
# Variable: SPEC_PATH: The path to your specs.				  
rspec: _verify_variable-SPEC_PATH
rspec:
	if [ -z "$(RSPEC_OPTIONS)" ] && [ ! -f ".rspec" ]; \
	then \
		echo -e "$(ERROR) You must either provide RSPEC_OPTIONS in your \
Makefile or a .rspec file in the root directory of this project."; \
		exit 1; \
	fi
rspec: BUNDLE_OPTIONS=rspec $(SPEC_PATH)
rspec: bundle_exec

.PHONY: rake
# Runs a Rake target.
# Variable: RAKE_TARGET: The Rake target to run, i.e. 'deploy' or 'clean.'
rake: _verify_variable-RAKE_TARGET
rake:
	if [ ! -f "Rakefile" ]; \
	then \
		echo -e "$(ERROR) A Rakefile must be present to run this target."; \
		exit 1; \
	fi
rake: BUNDLE_OPTIONS=rake $(RAKE_TARGET)
rake: bundle_exec
