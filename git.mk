#!/usr/bin/env make
ifndef TRAVIS_CI_GITHUB_TOKEN
$(error You need to define TRAVIS_CI_GITHUB_TOKEN first)
endif

.PHONY: _git_%
_git_%: GIT_ACTION=$(shell echo "$@" | cut -f3 -d _)
_git_%:
	docker run -t -v $$PWD:/work -w /work \
		-e MAKE_IS_RUNNING=true \
		alpine/git $(GIT_ACTION) $(GIT_OPTIONS)
