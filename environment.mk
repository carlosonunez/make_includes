#!/usr/bin/env make
.PHONY: _verify_example_env_is_present
_verify_example_env_is_present:
	if [ ! -f .env.example ]; \
	then \
		echo -e "$(ERROR) Please be nice to users and provide an .env.example."; \
		exit 1; \
	fi

.PHONY: _verify_real_env_is_present
# Checks for a .env in the local directory.
_verify_real_env_is_present:
	if [ ! -f .env ]; \
	then \
		echo -e "$(ERROR) Please provide a .env."; \
		exit 1; \
	fi

.PHONY: ensure_environment_is_configured
ensure_environment_is_configured: \
	_verify_example_env_is_present \
	_verify_real_env_is_present

ensure_environment_is_configured:
	cat .env.example | \
		cut -f1 -d '=' | \
		while read required_env_var; \
		do \
			if ! (env; cat .env) | grep -q "$$required_env_var"; \
			then \
				echo -e "$(ERROR): [$$required_env_var] is not configured in your \
environment. Please add it to your .env or Travis config."; \
				exit 1; \
			fi \
		done
