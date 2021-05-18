PYPY_VERSION = 3.7-v7.3.4
BUILD = 1
VERSION = $(PYPY_VERSION)-build$(BUILD)

PACKAGE = amazon2-pypy37

REPOSITORY = caltechads/amazon2-pypy37

#======================================================================

version:
	@echo ${VERSION}

image_name:
	@echo ${DOCKER_REGISTRY}/${PACKAGE}:${VERSION}

force-build:
	docker build -f Dockerfile.binary --no-cache -t ${PACKAGE}:${VERSION} .
	docker tag ${PACKAGE}:${VERSION} ${PACKAGE}:latest
	docker tag ${PACKAGE}:${VERSION} ${PACKAGE}:${PYPY_VERSION}
	docker image prune -f

build:
	docker build -f Dockerfile.binary -t ${PACKAGE}:${VERSION} .
	docker tag ${PACKAGE}:${VERSION} ${PACKAGE}:latest
	docker tag ${PACKAGE}:${VERSION} ${PACKAGE}:${PYPY_VERSION}
	docker image prune -f

force-build-src:
	docker build -f Dockerfile.src --no-cache -t ${PACKAGE}:${VERSION} .
	docker tag ${PACKAGE}:${VERSION} ${PACKAGE}:latest
	docker tag ${PACKAGE}:${VERSION} ${PACKAGE}:${PYPY_VERSION}
	docker image prune -f

build-src:
	docker build -f Dockerfile.src -t ${PACKAGE}:${VERSION} .
	docker tag ${PACKAGE}:${VERSION} ${PACKAGE}:latest
	docker tag ${PACKAGE}:${VERSION} ${PACKAGE}:${PYPY_VERSION}
	docker image prune -f

tag:
	docker tag ${PACKAGE}:${VERSION} ${REPOSITORY}:latest
	docker tag ${PACKAGE}:${VERSION} ${REPOSITORY}:${VERSION}
	docker tag ${PACKAGE}:${VERSION} ${REPOSITORY}:${PYPY_VERSION}

push:
	docker push ${REPOSITORY}

dev:
	docker-compose up

docker-clean:
	docker stop $(shell docker ps -a -q)
	docker rm $(shell docker ps -a -q)

exec:
	docker exec -ti amazon2-pypy37 bash
