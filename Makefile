# Variables
DOCKER_COMPOSE = docker compose
DOCKER_STACK = docker stack
SRC_DIR = ./srcs
STACK_NAME = app_stack
VERSION = v1.0

# Targets
all: build deploy

build:
	@echo "Building Docker images..."
	$(DOCKER_COMPOSE) -f $(SRC_DIR)/docker-compose.yml build
	@echo "Tagging Docker images with version: $(VERSION)"

deploy: init-swarm
	@echo "Deploying stack to Docker Swarm..."
	$(DOCKER_STACK) deploy -c $(SRC_DIR)/docker-compose.yml $(STACK_NAME)

init-swarm:
	@echo "Initializing Docker Swarm (if not already initialized)..."
	@if ! docker info | grep -q "Swarm: active"; then \
		docker swarm init; \
	fi

up: deploy
	@echo "Stack is up and running in Swarm mode."

down:
	@echo "Removing stack from Docker Swarm..."
	$(DOCKER_STACK) rm $(STACK_NAME)

clean: down
	@echo "Cleaning up dangling resources..."
	docker system prune -af --volumes

re: clean all

# For validating docker compose yaml file
validate: init-swarm
	@echo "Validating the docker-compose.yml configuration..."
	$(DOCKER_COMPOSE) -f $(SRC_DIR)/docker-compose.yml config

