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

.PHONY: _validate_example_env
# Validates that the example .env doesn't contain any potential secrets.
_validate_example_env:
	cat .env.example | \
		grep -v '^#' | \
		grep -v '^$$' | \
		while read -r line; \
		do \
			key=$$(echo "$$line" | cut -f1 -d =); \
			value=$$(echo "$$line" | sed 's/^[^=]*=//'); \
			if [ "$${value}" != "change_me" ]; \
			then \
				echo -e "$(ERROR) Key '$${key}' has an invalid value. \
It should be 'change_me'."; \
				exit 1; \
			fi; \
		done

.PHONY: _validate_real_env
# Validates that each environment in our example .env is present in our real
# environment.
_validate_real_env:
	cat .env.example | \
		grep -v '^#' | \
		grep -v '^$$' | \
		cut -f1 -d = | \
		while read required_env_var; \
		do \
			if ! (env; cat .env) | grep -q "$$required_env_var"; \
			then \
				echo -e "$(ERROR): [$$required_env_var] is not configured in your \
environment. Please add it to your .env."; \
				exit 1; \
			fi \
		done

.PHONY: _check_for_undocumented_environment_variables
_check_for_undocumented_environment_variables:
	cat .env | \
		grep -v '^#' | \
		grep -v '^$$' | \
		cut -f1 -d = | \
		while read defined_env_var; \
		do \
			if ! grep -qE "^$${defined_env_var}=" .env.example; \
			then \
				echo -e "$(ERROR) $${defined_env_var} is undocumented. \
Please add it to .env.example."; \
				exit 1; \
			fi; \
		done

.PHONY: validate_environment
validate_environment: \
	_verify_example_env_is_present \
	_verify_real_env_is_present \
	_validate_example_env \
	_validate_real_env \
	_check_for_undocumented_environment_variables
