HUGO ?= hugo
IMAGE ?= personal-site
PORT ?= 8080
BASE_URL ?= http://localhost:$(PORT)/

.PHONY: deps check-hugo dev build clean docker-build docker-run

# Resolve repository dependencies (theme submodule)
deps:
	git submodule update --init --recursive

# Ensure Hugo is available locally for dev/build commands.
check-hugo:
	@if command -v $(HUGO) >/dev/null 2>&1; then \
		exit 0; \
	fi; \
	if command -v nix >/dev/null 2>&1; then \
		echo "ERROR: '$(HUGO)' is not installed."; \
		echo "Run 'nix develop' (or enable direnv) and retry."; \
	else \
		echo "ERROR: '$(HUGO)' is not installed, and 'nix' is also unavailable."; \
		echo "Install Hugo directly, or install Nix and use 'nix develop'."; \
	fi; \
	exit 1

# Run local dev server
dev: deps check-hugo
	$(HUGO) server -D

# Build site
build: deps check-hugo
	$(HUGO)

# Remove generated files
clean:
	rm -rf public resources/_gen .hugo_build.lock

# Build Docker image (local baseURL)
docker-build: deps
	docker build --build-arg BASE_URL=$(BASE_URL) -t $(IMAGE) .

# Run Docker image locally
docker-run:
	docker run --rm -p $(PORT):80 $(IMAGE)
