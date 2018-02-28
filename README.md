This is an collection of Makefile includes that I've created over the years.

Since Make doesn't really support importing includes from remote destinations,
you should start your Makefile projects with this code:

```bash
MAKE_INCLUDES_FOUND := $(shell find . \
	-not -path "*/.git/*" \
	-type d | grep -E "^\./include/make$$")

ifeq ($(MAKE_INCLUDES_FOUND),)
$(warning "Make include files not found. Fetching them now.")
$(shell git clone 'https://github.com/carlosonunez/make_includes' include/make)
endif
```

Makefile variables required for each include can be obtained by running
`generate_documentation` within this repository.

# A note about re-using targets

Make will, by default, only run a target once, even if the target being run comes
from a pattern target. In other words, trying to run `bundle_exec` in a Makefile
that already runs a `bundle_exec` will only execute the *first* `bundle_exec` call.
To work around this, add a random string to the end of your call, such as
`bundle_exec_a86wj1`.

Enjoy!
