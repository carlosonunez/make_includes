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

Enjoy!
