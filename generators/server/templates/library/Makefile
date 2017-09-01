#!make
include .env
export $(shell sed 's/=.*//' .env)

DEV_SERVICE_NAME=${PROJECT}.dev
DOCKER_COMPOSE_BASE = docker-compose -f docker/docker-compose.yml
DOCKER_COMPOSE = ${DOCKER_COMPOSE_BASE}
DOCKER_RUN = ${DOCKER_COMPOSE} run --rm ${DEV_SERVICE_NAME}
DOCKER_RUN_NODEPS = ${DOCKER_COMPOSE} run --no-deps --rm ${DEV_SERVICE_NAME}
DOCKER_RUN_SYSTEMTEST = ${DOCKER_COMPOSE_SYSTEMTEST} run --service-ports --rm ${SYSTEMTEST_SERVICE_NAME}
DOCKER_COMPOSE_SYSTEMTEST = docker-compose -f docker/docker-compose.systemtest.yml

.PHONY: build dist start unittest systemtest login bash

# Build the development services.
build: clean
	${DOCKER_COMPOSE} build
	${DOCKER_RUN_NODEPS} gulp compile

build-all:
	-${DOCKER_COMPOSE} rm -f -v
	-docker rmi ${DOCKER_REGISTRY}/${PROJECT}
	-docker rmi ${DEV_SERVICE_NAME}
	-${DOCKER_COMPOSE} pull
	${DOCKER_COMPOSE} build --no-cache
	${DOCKER_RUN_NODEPS} gulp compile

# Start the development server and the defined services. It also watches for file changes. In this case, it re-runs the unit tests and restarts the server.
start:
	${DOCKER_COMPOSE} up

# Stop the development server and the defined services.
stop:
	${DOCKER_COMPOSE} kill

# Execute the unit tests
unittest:
	${DOCKER_RUN_NODEPS} gulp unittest


# Execute the system tests
systemtest-build:
	 ${DOCKER_COMPOSE_SYSTEMTEST} pull
	 ${DOCKER_COMPOSE_SYSTEMTEST} build

systemtest-compile:
	 ${DOCKER_COMPOSE_SYSTEMTEST} build

# The system test runner spins up all the dependencies, executes the system tests once, and exits. There are no logs of the dependencies displayed. If you want to see the whole picture, use:
# systemtest-run:
# 	 ${DOCKER_COMPOSE_SYSTEMTEST} up
#
# Don't check this change to github, because with this, Travis will fail!!! As it never stops...
systemtest-run: systemtest-compile
	 ${DOCKER_RUN_SYSTEMTEST}

# Start bash in the development service
bash:
	${DOCKER_RUN_NODEPS} /bin/bash

clean:
	rm -rf dist/*

# Push the distribution image to the registry
docker-push:
	docker push ${DOCKER_REGISTRY}/${PROJECT}

docker-pull:
	${DOCKER_COMPOSE_PROD} pull

# Tag the image after the latest npm tag
docker-tag:
	scripts/tag-image.sh ${DOCKER_REGISTRY}/${PROJECT}

# Login to the docker registry of the project
docker-login:
	docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD} http://${DOCKER_REGISTRY}

lint:
	${DOCKER_RUN_NODEPS} npm run lint
