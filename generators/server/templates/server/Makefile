#!make
include .env
export $(shell sed 's/=.*//' .env)

SERVICE_NAME=${PROJECT}
DEV_SERVICE_NAME=${SERVICE_NAME}.dev
DOCKER_COMPOSE_BASE = docker-compose -f docker/docker-compose.yml -f docker/docker-compose.net.yml -f docker/docker-compose.dependencies.yml
DOCKER_COMPOSE_BUILD = docker-compose -f docker/docker-compose.yml -f docker/docker-compose.dependencies.yml
DOCKER_COMPOSE_PROD = docker-compose -f docker/docker-compose.prod.yml
DOCKER_COMPOSE = ${DOCKER_COMPOSE_BASE}
DOCKER_RUN = ${DOCKER_COMPOSE} run --rm ${DEV_SERVICE_NAME}
DOCKER_RUN_NODEPS = ${DOCKER_COMPOSE} run --no-deps --rm ${DEV_SERVICE_NAME}

ifeq ($(DEBUG),true)
  DOCKER_COMPOSE = ${DOCKER_COMPOSE_BASE} -f docker/docker-compose.debug.yml
	DOCKER_RUN = ${DOCKER_COMPOSE} run --service-ports --rm ${DEV_SERVICE_NAME}
	DOCKER_RUN_NODEPS = ${DOCKER_COMPOSE} run --no-deps --service-ports --rm ${DEV_SERVICE_NAME}
endif

.PHONY: build dist test up stop rm-volumes rm destroy ps logs

# Build the development services.
build:
	-${DOCKER_COMPOSE_BUILD} build
	-${DOCKER_RUN_NODEPS} gulp compile


build-all:
	-${DOCKER_COMPOSE} pull
	-${DOCKER_COMPOSE_BUILD} build
	-${DOCKER_RUN_NODEPS} gulp compile
	-docker build -t ${DOCKER_REGISTRY}/${TARGET_IMAGE_NAME} .
	-npm run setup

# Build the distribution package
dist:
	docker build -t ${DOCKER_REGISTRY}/${TARGET_IMAGE_NAME} .


# Start the development server and the defined services. It also watches for file changes. In this case, it re-runs the unit tests and restarts the server.
start:
	${DOCKER_COMPOSE} up


# Start the development server and the defined services. It also watches for file changes. In this case, it re-runs the unit tests and restarts the server.
start-d:
	${DOCKER_COMPOSE} up -d


# Stop the development server
stop:
	${DOCKER_COMPOSE} stop ${DEV_SERVICE_NAME}


# Start the production server and the defined services.
start-prod:
	${DOCKER_COMPOSE_PROD} up -d


# Start the production server and the defined services.
stop-prod:
	${DOCKER_COMPOSE_PROD} down


# List the running processes related to the server
logs-prod:
	${DOCKER_COMPOSE_PROD} logs -f


# Stop the development server and the services
stop-all:
	${DOCKER_COMPOSE} stop


# Restart the development server
restart:
	${DOCKER_COMPOSE} restart ${DEV_SERVICE_NAME}


# Stop the development server and the services
restart-all:
	${DOCKER_COMPOSE} restart


# Kill the development server but let the other services run.
kill:
	${DOCKER_COMPOSE} kill ${DEV_SERVICE_NAME}


# Kill the development server but let the other services run.
kill-all:
	${DOCKER_COMPOSE} kill


# Execute the unit tests
unittest:
	${DOCKER_RUN_NODEPS} gulp unittest


# Execute the system tests
systemtest:
	${DOCKER_RUN} scripts/systemtest.sh


# Execute the smoke tests
smoketest:
	test/smoke/smoke_test.sh


# List the running processes related to the server
ps:
	${DOCKER_COMPOSE} ps


# List the running processes related to the server
logs:
	${DOCKER_COMPOSE} logs -f ${DEV_SERVICE_NAME}


# List the running processes related to the server
logs-all:
	${DOCKER_COMPOSE} logs -f


# Login to the docker registry of the project
login:
	docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD} http://${DOCKER_REGISTRY}


# Push the distribution image to the registry
push:
	docker push ${DOCKER_REGISTRY}/${TARGET_IMAGE_NAME}


# Start bash in the development service
bash:
	${DOCKER_RUN} /bin/bash


# Remove all the images
clean:
	-${DOCKER_COMPOSE} rm -f -v
	-docker rmi ${DOCKER_REGISTRY}/${TARGET_IMAGE_NAME}
	-docker rmi docker_${DEV_SERVICE_NAME}
	-rm -rf dist

# Kill and delete everything
destroy: kill-all clean


# Start the services in debug mode
debug:
	${DOCKER_RUN} gulp debug


# Tag the image after the latest npm tag
tag:
	scripts/tag-image.sh ${DOCKER_REGISTRY}/${TARGET_IMAGE_NAME}
