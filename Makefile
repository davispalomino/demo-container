# service - variables
PROJECT = falcon
ENV     = prd
SERVICE = demo

# docker - variable
REPO_PATH       = $(REPO_HOST)/$(PROJECT)-$(ENV)/$(SERVICE)
BUILD_UID       = $(shell id -u)
BUILD_GID       = $(shell id -g)
BUILD_USERNAME  = $(shell whoami)

image:
	# creando imagen base
	@docker build -f docker/base/Dockerfile -t $(PROJECT)-$(ENV)-$(SERVICE):base .

release:
	@docker build -f docker/latest/Dockerfile --build-arg IMAGE=$(PROJECT)-$(ENV)-$(SERVICE):base -t $(PROJECT)-$(ENV)-$(SERVICE):app .

newmantest:
	# Create image Docker build Newman
	docker build --network host -f docker/newman/Dockerfile -t $(PROJECT)-$(ENV)-$(SERVICE):newman .
	# Docker-compose UP
	IMAGE_APP=$(PROJECT)-$(ENV)-$(SERVICE):app IMAGE_NEWMAN=$(PROJECT)-$(ENV)-$(SERVICE):newman MICROSERVICE=$(PROJECT)-$(ENV)-$(SERVICE) docker-compose up -d && IMAGE_APP=$(PROJECT)-$(ENV)-$(SERVICE):app IMAGE_NEWMAN=$(PROJECT)-$(ENV)-$(SERVICE):newman MICROSERVICE=$(PROJECT)-$(ENV)-$(SERVICE) docker-compose down
