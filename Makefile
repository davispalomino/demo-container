# service - variables
PROJECT 		= falcon
ENV     		= prd
SERVICE 		= demo
AWS_REGION		= us-east-1
AWS_ACCOUNT_ID = 508571872065
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

pushecr:
	aws ecr describe-repositories --repository-names $(PROJECT)-$(ENV)-$(SERVICE) --query "repositories[0].repositoryUri" --region $(AWS_REGION) --output text 2>/dev/null || aws ecr create-repository --repository-name $(PROJECT)-$(ENV)-$(SERVICE)  --query "repository.repositoryUri" --region $(AWS_REGION) --output text
	@aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com
	docker tag $(PROJECT)-$(ENV)-$(SERVICE):app $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(PROJECT)-$(ENV)-$(SERVICE):$(BUILD_TIMESTAMP)
	@docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(PROJECT)-$(ENV)-$(SERVICE):$(BUILD_TIMESTAMP)
