#!make
include .env
export $(shell sed 's/=.*//' .env)

DOCKER_RUN = docker run --rm -v "${PWD}:/app/project" ${DOCKER_REGISTRY}/workflows-server

.PHONY: build dist start unittest systemtest login bash

# Build the development services.
build:
	${DOCKER_RUN} gulp compile


# Start the development server and the defined services. It also watches for file changes. In this case, it re-runs the unit tests and restarts the server.
start:
	${DOCKER_RUN} gulp


# Execute the unit tests
unittest:
	${DOCKER_RUN} gulp unittest


# Execute the system tests
systemtest:
	${DOCKER_RUN} scripts/systemtest.sh


# Login to the docker registry of the project
login:
	docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD} http://${DOCKER_REGISTRY}


# Start bash in the development service
bash:
	${DOCKER_RUN} /bin/bash

