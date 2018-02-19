#!/usr/bin/env make
.PHONY: _git_%
# Variable: GIT_ACTION: The action to perform, such as 'clone' or 'status'.
# Variable: GIT_OPTIONS: Additional options to provide to Git.
_git_%: GIT_ACTION=$(shell echo "$@" | cut -f3 -d _)
_git_%:
	docker run -t -v $$PWD:/work -w /work \
		-e MAKE_IS_RUNNING=true \
		alpine/git $(GIT_ACTION) $(GIT_OPTIONS)
