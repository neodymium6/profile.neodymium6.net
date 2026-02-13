HUGO ?= hugo
IMAGE ?= personal-site
PORT ?= 8080
BASE_URL ?= http://localhost:$(PORT)/

.PHONY: dev build clean docker-build docker-run

# Run local dev server

dev:
	$(HUGO) server -D

# Build site
build:
	$(HUGO)

# Remove generated files
clean:
	rm -rf public resources/_gen .hugo_build.lock

# Build Docker image (local baseURL)
docker-build:
	docker build --build-arg BASE_URL=$(BASE_URL) -t $(IMAGE) .

# Run Docker image locally
docker-run:
	docker run --rm -p $(PORT):80 $(IMAGE)
