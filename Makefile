HUGO ?= hugo

.PHONY: dev build clean

# Run local dev server

dev:
	$(HUGO) server -D

# Build site
build:
	$(HUGO)

# Remove generated files
clean:
	rm -rf public resources/_gen .hugo_build.lock
