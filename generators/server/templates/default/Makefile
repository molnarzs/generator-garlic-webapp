#!make
include .env
export $(shell sed 's/=.*//' .env)

SERVICE_NAME=${SCOPE}.${PROJECT}
DEV_SERVICE_NAME=${SERVICE_NAME}.dev
DOCKER_COMPOSE = docker-compose -f docker/docker-compose.yml
DOCKER_RUN = ${DOCKER_COMPOSE} run --no-deps --rm ${DEV_SERVICE_NAME}

ifneq ($(TRAVIS),true)
	DOCKER_COMPOSE = docker-compose -f docker/docker-compose.yml -f docker/docker-compose.debug.yml
	DOCKER_RUN = ${DOCKER_COMPOSE} run --no-deps --service-ports --rm ${DEV_SERVICE_NAME}
endif

.PHONY: build dist test up stop rm-volumes rm destroy ps logs

# Build the development services.
build:
	${DOCKER_COMPOSE} build
	${DOCKER_RUN} gulp compile


# Start the development server and the defined services. It also watches for file changes. In this case, it re-runs the unit tests and restarts the server.
start:
	${DOCKER_COMPOSE} up


# Build the distribution package
dist:
	docker build -t ${DOCKER_REGISTRY}/${TARGET_IMAGE_NAME} .


# Start the development server and the defined services. It also watches for file changes. In this case, it re-runs the unit tests and restarts the server.
start-d:
	${DOCKER_COMPOSE} up -d


# Stop the development server
stop:
	${DOCKER_COMPOSE} stop ${DEV_SERVICE_NAME}


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
	${DOCKER_RUN} gulp unittest


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
push: login dist
	docker push ${DOCKER_REGISTRY}/${TARGET_IMAGE_NAME}


# Start bash in the development service
bash:
	${DOCKER_RUN} /bin/bash


# Remove all the images
clean:
	-${DOCKER_COMPOSE} rm -f -v
	-docker rmi ${SERVICE_NAME}


# Kill and delete everything
destroy: kill-all clean

# Start the services in debug mode
debug:
	${DOCKER_COMPOSE} run --rm ${DEV_SERVICE_NAME} scripts/debug.sh
