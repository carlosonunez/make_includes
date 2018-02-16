This is an collection of Makefile includes that I've created over the years.

Since Make doesn't really support importing includes from remote destinations,
you'll need to do something like this for your project:

```bash
git clone https://github.com/carlosonunez/make_includes include/make
```

Makefile variables required for each include can be obtained by running
`generate_documentation` within this repository.

Enjoy!
