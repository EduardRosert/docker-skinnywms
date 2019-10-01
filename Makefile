all: build-image

build-image:
	docker build \
		--build-arg http_proxy=$$http_proxy \
		--build-arg https_proxy=$$https_proxy \
		--file Dockerfile \
		--tag eduardrosert/skinnywms:latest \
		.

build-image-no-cache:
	docker build \
		--no-cache \
		--build-arg http_proxy=$$http_proxy \
		--build-arg https_proxy=$$https_proxy \
		--file Dockerfile \
		--tag eduardrosert/skinnywms:latest \
		.