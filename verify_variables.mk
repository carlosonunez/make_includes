#!/usr/bin/env make
.PHONY: _verify_variable-%
_verify_variable-%:
	@ if [ "${${*}}" == "" ]; \
		then \
			echo "Please define: $*"; \
			exit 1; \
		fi
