#!make
include .env
export $(shell sed 's/=.*//' .env)

DEV_SERVICE_NAME=${SCOPE}.${PROJECT}.backend
DOCKER_COMPOSE_BASE = docker-compose -f docker/docker-compose.backend.yml
DOCKER_COMPOSE = ${DOCKER_COMPOSE_BASE}
DOCKER_RUN = ${DOCKER_COMPOSE} run --rm ${DEV_SERVICE_NAME}
DOCKER_RUN_NODEPS = ${DOCKER_COMPOSE} run --no-deps --rm ${DEV_SERVICE_NAME}

ifeq ($(DEBUG),true)
  DOCKER_COMPOSE = ${DOCKER_COMPOSE_BASE} -f docker/docker-compose.debug.yml
	DOCKER_RUN = ${DOCKER_COMPOSE} run --service-ports --rm ${DEV_SERVICE_NAME}
	DOCKER_RUN_NODEPS = ${DOCKER_COMPOSE} run --no-deps --service-ports --rm ${DEV_SERVICE_NAME}
endif

.PHONY: build dist start unittest systemtest login bash

# Build the development services.
build:
	${DOCKER_COMPOSE} build
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

# Login to the docker registry of the project
login:
	docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD} http://${DOCKER_REGISTRY}

# Start bash in the development service
bash:
	${DOCKER_RUN_NODEPS} /bin/bash
