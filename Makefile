# version tags
SKINNYWMS_VERSION := 0.2.1

# test
TEST_CMD := python /app/skinnywms/demo.py --host='0.0.0.0' --port=5000

# META
DOCKER_REPO := eduardrosert/skinnywms
SOURCE_COMMIT := $(shell git rev-parse HEAD)
GIT_TAG  := $(shell git tag)

# Find out if the working directory is clean
GIT_NOT_CLEAN_CHECK := $(shell git status --porcelain)
ifneq (x${GIT_NOT_CLEAN_CHECK}, x)
DOCKER_TAG_SUFFIX = "-dirty"
endif

GIT_URL := $$(git remote get-url --push origin)
LATEST  := ${DOCKER_REPO}:latest
DATE    := $$(date -u +%Y-%m-%dT%H:%M:%SZ)

# If this is not a tagged version
# replace docker tag with 'latest'
ifeq ('${GIT_TAG}','')
DOCKER_TAG = latest
else
DOCKER_TAG = version-${GIT_TAG}
endif
IMAGE_NAME = ${DOCKER_REPO}:${DOCKER_TAG}${DOCKER_TAG_SUFFIX}


# If this git repo has no remote
# url, set it to <unknown>
ifeq ('${GIT_URL}','')
GIT_URL = <unknown>
endif

all: build

.PHONY: build run run-interactive test login login-user-pass push clean

build:
	@echo "Building ${IMAGE_NAME} ..."
	@docker build \
		--build-arg SKINNYWMS_VERSION=${MAGICS_BUNDLE_VERSION} \
		--build-arg BUILD_DATE=${DATE} \
		--build-arg VCS_URL=${GIT_URL} \
		--build-arg VCS_REF=${SOURCE_COMMIT} \
		--build-arg VERSION=${DOCKER_TAG} \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--build-arg ftp_proxy=${ftp_proxy} \
		--build-arg no_proxy="${no_proxy}" \
		--file Dockerfile \
		--tag ${IMAGE_NAME} \
		.
	@docker tag ${IMAGE_NAME} ${LATEST}

run:
	@docker run --rm -i -t ${IMAGE_NAME}

run-interactive:
	@docker run --rm -i -t ${IMAGE_NAME} sh

test:
	@docker run --rm -i -t ${IMAGE_NAME} ${TEST_CMD}

login:
	@docker login

login-user-pass:
	@docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}

push: login
	@docker push ${DOCKER_REPO}

clean:
	@docker rmi ${DOCKER_REPO}